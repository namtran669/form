import 'dart:convert';
import 'dart:convert' as convert;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:core/core.dart';
import 'package:data/src/constants/sign_in_step.dart';
import 'package:data/src/di/locator.dart';
import 'package:data/src/models/app_user_data_model.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

import '../data_source/local/shared_preferences_store.dart';
import '../data_source/remote/auth_resend_otp_api.dart';
import '../data_source/remote/base/api_endpoint.dart';
import '../data_source/remote/confirm_forgot_password_api.dart';
import '../data_source/remote/confirm_sign_in_api.dart';
import '../data_source/remote/forgot_password_api.dart';
import '../data_source/remote/sign_in_api.dart';
import '../data_source/remote/user_update_fcm_token_api.dart';
import 'base/base_repository.dart';

class AuthenticationRepoImpl extends BaseRepository
    implements AuthenticationRepo {
  var userData = AppUserDataModel();

  final SharedPrefsStore _storage;
  final OtpAuthResendApi _otpAuthResendApi;
  final ForgotPasswordApi _forgotPasswordApi;
  final ConfirmForgotPasswordApi _confirmForgotPasswordApi;
  final UserUpdateFcmTokenApi _userUpdateFcmTokenApi;
  final ConfirmSignInApi _confirmSignInApi;
  final SignInApi _signInApi;

  AuthenticationRepoImpl(
    this._storage,
    this._otpAuthResendApi,
    this._forgotPasswordApi,
    this._confirmForgotPasswordApi,
    this._userUpdateFcmTokenApi,
    this._confirmSignInApi,
    this._signInApi,
  );

  @override
  Future<Result<AppUserData>> signIn(String username, String password) async {
    userData.userEmail = username;

    try {
      await signOut();
      var login = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      if (login.isSignedIn) {
        userData.signInStep = SignInStep.settingMfa;
        var userAttributes = await Amplify.Auth.fetchUserAttributes();
        for (final element in userAttributes) {
          if (element.userAttributeKey.key == 'custom:mfa') {
            userData.signInStep = SignInStep.inputOtp;
          }
        }

        var result = await _signInApi.signIn(
          username,
          locator<AppConfig>().awsClientId,
          userData.sessionId,
          userData.internalToken,
        );

        if (ApiStatusCode.SUCCESS == result.statusCode) {
          var responseJson =
              convert.jsonDecode(result.data) as Map<String, dynamic>;
          userData.loginSession = responseJson['Session'];
          var challenge =
              responseJson['ChallengeParameters'] as Map<String, dynamic>;
          userData.sessionId = challenge['session_id'];
          userData.internalToken = challenge['access_token'];
          await fetchSession();
          return Success(userData);
        } else {
          return Error(ErrorType.GENERIC, result.data);
        }
      } else {
        String? signInStep = login.nextStep?.signInStep;
        if (signInStep != null) {
          userData.signInStep = signInStep;
          await fetchSession();
          return Success(userData);
        } else {
          return Error(ErrorType.GENERIC, Strings.tr.errorCannotLogin);
        }
      }
    } on AuthException catch (e) {
      return Error(ErrorType.GENERIC, e.message);
    }
  }

  @override
  Future<Result> signOut() async {
    try {
      await Amplify.Auth.signOut();
      _storage.clearUserData();
      _storage.saveDisplayedOnboardScreen();
      return Success(true);
    } on AuthException catch (e) {
      return Error(ErrorType.GENERIC, e.message);
    }
  }

  @override
  Future<Result<AppUserData>> fetchSession() async {
    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      CognitoAuthSession session = res as CognitoAuthSession;

      String? accessToken = session.userPoolTokens?.accessToken;
      String? refreshToken = session.userPoolTokens?.refreshToken;
      if (accessToken != null && refreshToken != null) {
        userData.accessToken = accessToken;
        userData.refreshToken = refreshToken;
        _storage.saveUserData(userData);
      }
    } on AuthException catch (e) {
      return Error(ErrorType.GENERIC, e.message);
    }
    return Success(userData);
  }

  @override
  Future<Result<bool>> confirmAccount(String newPassword) async {
    try {
      await Amplify.Auth.confirmSignIn(confirmationValue: newPassword);
      await fetchSession();
      return Success(true);
    } on AuthException catch (e) {
      return Error(ErrorType.GENERIC, e.message);
    }
  }

  @override
  Future<Result<bool>> confirmSignIn(String otp) async {
    try {
      var result = await _confirmSignInApi.confirm(
        userData.userEmail,
        otp,
        locator<AppConfig>().awsClientId,
        userData.sessionId,
        userData.internalToken,
        userData.loginSession,
      );

      if (ApiStatusCode.SUCCESS == result.statusCode) {
        var confirmResult =
            convert.jsonDecode(result.data) as Map<String, dynamic>;
        if (confirmResult.containsKey('AuthenticationResult')) {
          userData.signInStep = SignInStep.done;
          await fetchSession();
          return Success(true);
        } else {
          if (confirmResult.containsKey('Session')) {
            userData.loginSession = confirmResult['Session'];
          }
          return Error(ErrorType.GENERIC, Strings.tr.errorOtpInvalid);
        }
      } else {
        return Error(ErrorType.GENERIC, Strings.tr.errorOtpInvalid);
      }
    } on AuthException {
      return Error(ErrorType.GENERIC, Strings.tr.errorOtpInvalid);
    }
  }

  @override
  Future<Result<AppUserData>> requestResendOtp() {
    return safeApiCall(
        _otpAuthResendApi.request(
          userData.userEmail!,
          userData.sessionId!,
          userData.internalToken!,
        ), mapper: (data) {
      var response = data as Map<String, dynamic>;
      userData.sessionId = response['sessionId'];
      userData.internalToken = response['accessToken'];
      return userData;
    });
  }

  @override
  Future<Result> forgotPassword(String email) {
    return safeApiCallGetResponse(_forgotPasswordApi.request(email));
  }

  @override
  Future<Result> confirmForgotPassword(
    String email,
    String password,
    String code,
  ) async {
    return safeApiCallGetResponse(_confirmForgotPasswordApi.request(
      email,
      password,
      code,
    ));
  }

  @override
  Future<bool> updateFcmToken(String token, String platform) async {
    bool updateSuccess = false;
    int retry = 3;
    var result = await safeApiCallGetResponse(_userUpdateFcmTokenApi.update(
      userData.accessToken!,
      token,
      platform,
    ));
    result.when(success: (data) {
      updateSuccess = ApiStatusCode.SUCCESS == data.statusCode;
    }, error: (e) async {
      while (retry > 0) {
        var retryResult =
            await safeApiCallGetResponse(_userUpdateFcmTokenApi.update(
          userData.accessToken!,
          token,
          platform,
        ));
        retryResult.when(success: (data) {
          updateSuccess = ApiStatusCode.SUCCESS == data.statusCode;
          retry = 0;
        }, error: (e) {
          retry--;
        });
      }
    });
    return updateSuccess;
  }
}

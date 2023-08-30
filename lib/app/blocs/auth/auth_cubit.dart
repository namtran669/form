import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../routes/routes.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignIn _signIn;
  final SignOut _signOut;
  final ConfirmAccount _confirmAccount;
  final ConfirmSignIn _confirmSignIn;
  final LocalAuthentication localAuth;
  final RequestOtpAuthResend _requestOtpAuthResend;

  final AuthenticationRepo _authenticationRepo;

  String? otp;

  AuthCubit(
    this._signIn,
    this._signOut,
    this._confirmAccount,
    this._confirmSignIn,
    this.localAuth,
    this._requestOtpAuthResend,
    this._authenticationRepo,
  ) : super(AuthInitial());

  login(String email, String password) async {
    AppUserDataModel().email = email;
    emit(AuthInProgress());
    var signIn = await _signIn.call(param: LoginRequest(email, password));
    signIn.when(
      success: (signInResult) async {
        switch (signInResult.signInStep) {
          case SignInStep.newPassword:
            emit(const AuthLoginSuccess(Routes.confirmAccount));
            break;
          case SignInStep.settingMfa:
            emit(const AuthLoginSuccess(Routes.mfaSelectType));
            break;
          case SignInStep.inputOtp:
            emit(const AuthLoginSuccess(Routes.authInputOtp));
            break;
          default:
            emit(const AuthLoginSuccess(Routes.main));
            break;
        }
      },
      error: (error) => emit(AuthLoginFailed(error.message)),
    );
  }

  confirmAccount(String newPassword) async {
    emit(AuthInProgress());
    var result = await _confirmAccount.call(param: newPassword);
    result.when(success: (_) async {
      emit(AuthConfirmAccountSuccess());
    }, error: (ex) {
      emit(AuthUpdatePasswordFail(ex.message));
    });
  }

  confirmSignIn() async {
    if (otp == null || otp!.isEmpty) {
      emit(const AuthConfirmSignInFail('Confirm code is required.'));
      emit(AuthInitial());
    } else if (otp!.length < 6) {
      emit(const AuthConfirmSignInFail('Code must be 6 characters.'));
      emit(AuthInitial());
    } else {
      emit(AuthConfirmingSignIn());
      var confirmSignInResult = await _confirmSignIn.call(param: otp);
      confirmSignInResult.when(
          success: (_) {
            emit(const AuthLoginSuccess(Routes.main));
          },
          error: (err) => emit(AuthConfirmSignInFail(err.message)));
    }
  }

  authenticateBiometrics() async {
    emit(AuthInProgress());
    try {
      final isAvailable = await localAuth.canCheckBiometrics;
      if (isAvailable) {
        bool isAuthenticated = await localAuth.authenticate(
          localizedReason: 'Scan your fingerprint '
              '(or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (isAuthenticated) {
          emit(const AuthLoginSuccess(Routes.main));
        } else {
          emit(const AuthLoginFailed('Login failed.'));
        }
      } else {
        emit(const AuthLoginFailed('Biometric is not supported.'));
      }
    } on PlatformException catch (e) {
      emit(const AuthLoginFailed('Biometric is error.'));
    }
  }

  checkBiometricSupportType() async {
    List<BiometricType> types = await localAuth.getAvailableBiometrics();
    if (types.isNotEmpty) {
      emit(AuthSupportType(types[0]));
    }
  }

  requestNewOtp() async {
    await _requestOtpAuthResend.call();
    emit(const AuthRequestNewOtpSuccess('A new OTP code has been sent.'));
  }

  logout() async {
    var signOut = await _signOut.call();
    signOut.when(success: (_) {
      emit(AuthLogoutSuccess());
    }, error: (err) {
      emit(AuthLogoutFail(err.message));
    });
  }

  forgotPassword(String email) async {
    emit(AuthInProgress());
    var result = await _authenticationRepo.forgotPassword(email);
    result.when(
      success: (data) {
        if (data != null) {
          emit(AuthRequestForgotPasswordSuccess());
        }
      },
      error: (error) {
        emit(AuthRequestForgotPasswordError(error.message));
      },
    );
  }

  resendVerificationCodeForgotPassword(String email) async {
    var result = await _authenticationRepo.forgotPassword(email);
    result.when(
      success: (data) {
        if (data != null) {
          emit(AuthRequestForgotPasswordCodeSuccess());
        }
      },
      error: (error) {
        emit(AuthRequestForgotPasswordError(error.message));
      },
    );
  }

  confirmForgotPassword(String email, String password, String code) async {
    emit(AuthInProgress());
    var result = await _authenticationRepo.confirmForgotPassword(
      email,
      password,
      code,
    );

    result.when(
      success: (data) {
        if (data != null) {
          emit(AuthConfirmForgotPasswordSuccess());
        }
      },
      error: (error) {
        emit(AuthConfirmForgotPasswordError(error.message));
      },
    );
  }

  updateFcmToken(String? token, String platform) async {
    if(token != null) {
      await _authenticationRepo.updateFcmToken(token, platform);
    }
  }
}

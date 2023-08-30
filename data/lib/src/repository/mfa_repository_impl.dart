import 'package:data/data.dart';
import 'package:data/src/data_source/remote/mfa_otp_verification_challenge_api.dart';
import 'package:data/src/data_source/remote/mfa_setting_api.dart';
import 'package:data/src/data_source/remote/mfa_verify_otp_api.dart';
import 'package:data/src/repository/base/base_repository.dart';
import 'package:domain/domain.dart';

import '../data_source/local/shared_preferences_store.dart';

class MfaRepoImpl extends BaseRepository implements MfaRepo {
  final MfaSettingApi _mfaSettingApi;
  final MfaOtpVerificationChallengeApi _otpVerificationChallengeApi;
  final MfaVerifyOtpApi _verifyOtpApi;

  final SharedPrefsStore _localStorage;

  late int _sessionId;
  final AppUserData _userData = AppUserDataModel();

  MfaRepoImpl(
    this._mfaSettingApi,
    this._otpVerificationChallengeApi,
    this._verifyOtpApi,
    this._localStorage,
  );

  @override
  Future<Result<bool>> mfaSetting(bool isPhone, {String? phoneNo}) async {
    try {
      var body;
      if (isPhone) {
        body = MfaSettingBody(false, 'sms', phoneNumber: phoneNo);
      } else {
        body = MfaSettingBody(true, 'email');
      }
      final isDone = await _mfaSettingApi.setting(
        _userData.accessToken!,
        body,
      );
      if (isDone) {
        _userData.signInStep = SignInStep.done;
        _localStorage.saveUserData(_userData);
        return Success(isDone);
      } else {
        return Error(
          ErrorType.GENERIC,
          'Can not set device, please try again.',
        );
      }
    } catch (e) {
      return Error(
        ErrorType.GENERIC,
        'There is an issue with the network, please try again.',
      );
    }
  }

  @override
  Future<Result<int>> requestOtpVerifyChallenge(String phoneNumber) async {
    try {
      var result = await _otpVerificationChallengeApi.request(
        _userData.accessToken!,
        phoneNumber,
      );
      if (result.statusCode == 200) {
        int id = (result.data as Map<String, dynamic>)['sessionId'];
        _sessionId = id;
        _localStorage.setInt(PreferencesKey.SESSION_ID, _sessionId);
        return Success(_sessionId);
      } else {
        return Error(ErrorType.GENERIC, result.statusMessage ?? '');
      }
    } catch (e) {
      return Error(
        ErrorType.GENERIC,
        'There is an issue with the network, please try again or later',
      );
    }
  }

  @override
  Future<Result<bool>> verifyMfaOtp(String otp) async {
    String sessionStr = await _localStorage.getSessionID();
    _sessionId = int.parse(sessionStr);

    try {
      var result = await _verifyOtpApi.verify(
        _userData.accessToken!,
        _sessionId,
        otp,
      );

      if (result.statusCode == 200) {
        bool isValid = (result.data as Map<String, dynamic>)['success'];
        if (isValid) {
          _userData.signInStep = SignInStep.done;
          _localStorage.saveUserData(_userData);
          return Success(isValid);
        } else {
          return Error(
            ErrorType.GENERIC,
            'The OTP inputted is incorrect.',
          );
        }
      } else {
        return Error(
          ErrorType.GENERIC,
          result.statusMessage ?? '',
        );
      }
    } catch (e) {
      return Error(
        ErrorType.GENERIC,
        'There is an issue with the network, please try again or later',
      );
    }
  }
}

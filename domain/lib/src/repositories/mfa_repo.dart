import '../../domain.dart';

abstract class MfaRepo {
  Future<Result<bool>> mfaSetting(bool isPhone, {String? phoneNo});

  Future<Result<int>> requestOtpVerifyChallenge(String phoneNumber);

  Future<Result<bool>> verifyMfaOtp(String otp);
}
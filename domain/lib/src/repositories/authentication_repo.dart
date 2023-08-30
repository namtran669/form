import '../../domain.dart';

abstract class AuthenticationRepo {
  Future<Result<AppUserData>> signIn(String username, String password);

  Future<Result> signOut();

  Future<Result<AppUserData>> fetchSession();

  Future<Result<bool>> confirmAccount(String newPassword);

  Future<Result<bool>> confirmSignIn(String otp);

  Future<Result<AppUserData>> requestResendOtp();

  Future<Result> forgotPassword(String email);

  Future<Result> confirmForgotPassword(String email, String password, String code);

  Future<bool> updateFcmToken(String token, String platform);
}
import 'package:domain/domain.dart';

abstract class UserDataRepo {
  Future<bool> hasUserData();

  Future<AppUserData?> get userData;

  Future saveUserData(AppUserData data);

  Future<Result<AppUserData>> fetchUserProfile();

  Future<Result> changePassword(String oldPassword, String newPassword);

  Future<Result> sendUserFeedback(String feedback);

  Future<bool> isFirstTimeLogin();
}

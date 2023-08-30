import 'package:data/src/models/app_user_data_model.dart';
import 'package:data/src/repository/base/base_repository.dart';
import 'package:domain/domain.dart';

import '../data_source/local/shared_preferences_store.dart';
import '../data_source/remote/change_password_api.dart';
import '../data_source/remote/user_feedback_api.dart';
import '../data_source/remote/user_profile_api.dart';

class UserDataRepoImpl extends BaseRepository implements UserDataRepo {
  final SharedPrefsStore _storage;
  final UserProfileApi _userProfileApi;
  final ChangePasswordApi _changePasswordApi;
  final UserFeedbackApi _userFeedbackApi;

  UserDataRepoImpl(
    this._storage,
    this._userProfileApi,
    this._changePasswordApi,
    this._userFeedbackApi,
  );

  final AppUserData _userData = AppUserDataModel();

  @override
  Future<void> saveUserData(AppUserData user) async {
    return await _storage.saveUserData(user);
  }

  @override
  Future<AppUserData?> get userData async {
    bool hasData = await hasUserData();
    return hasData
        ? AppUserDataModel.fromJsonString(await _storage.getUserDataJson())
        : null;
  }

  @override
  Future<bool> hasUserData() async {
    return await _storage.hasUserData();
  }

  @override
  Future<Result<AppUserData>> fetchUserProfile() {
    return safeApiCall<AppUserData>(
      _userProfileApi.get(_userData.accessToken!),
      mapper: (data) {
        Map<String, dynamic> userDataJson =
            (data as Map<String, dynamic>)['data'];
        _userData.mfaOption = userDataJson['mfaOption'];
        _userData.phone = userDataJson['phone'];
        _userData.email = userDataJson['email'];
        _userData.firstName = userDataJson['firstName'];
        _userData.lastName = userDataJson['lastName'];
        _userData.roleShortName =  userDataJson['roleShortName'];
        _userData.roleName =  userDataJson['roleName'];
        return _userData;
      },
    );
  }

  @override
  Future<Result> changePassword(
    String oldPassword,
    String newPassword,
  ) {
    return safeApiCallGetResponse(_changePasswordApi.request(
      _userData.accessToken!,
      oldPassword,
      newPassword,
    ));
  }

  @override
  Future<Result> sendUserFeedback(String feedback) {
    return safeApiCallGetResponse(_userFeedbackApi.post(
      _userData.accessToken!,
      feedback,
    ));
  }

  @override
  Future<bool> isFirstTimeLogin() async {
    return await _storage.isFirstTimeLogin();
  }
}

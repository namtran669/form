import 'package:bloc/bloc.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:talosix/app/constants/app_constants.dart';

part 'user_profile_state.dart';

class AppUserProfileCubit extends Cubit<AppUserProfileState> {
  AppUserProfileCubit(this._userDataRepo) : super(UserInitial());

  final UserDataRepo _userDataRepo;

  final AppUserData userData = AppUserDataModel();

  fetchUserProfile() async {
    emit(UserFetchProfileInProgress());
    var result = await _userDataRepo.fetchUserProfile();
    result.when(
      success: (data) {
        if(!AppConstants.appRoles.contains(data.roleShortName)) {
          emit(UserInvalidRole());
        } else {
          emit(UserFetchProfileSuccess(data.firstName!));
        }
      },
      error: (error) => emit(UserFetchProfileError(error.message))
    );
  }

  changePassword(String oldPsd, String newPsd) async {
    emit(UserFetchProfileInProgress());
    var result = await _userDataRepo.changePassword(oldPsd, newPsd);
    result.when(
      success: (data) {
        if(data != null) {
          emit(UserChangePasswordSuccess());
        } else {
          emit(UserFetchProfileError(''));
        }
      },
      error: (err) {
        emit(UserChangePasswordError(err.message));
      }
    );
  }

  sendFeedback(String feedback) async {
    emit(AppUserSendFeedbackInProgress());
    var result = await _userDataRepo.sendUserFeedback(feedback);
    result.when(
      success: (data) {
        emit(AppUserSendFeedbackSuccess());
      },
      error: (err) {
        emit(AppUserSendFeedbackError(err.message));
      }
    );
  }
}

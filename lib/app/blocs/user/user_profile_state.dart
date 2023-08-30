part of 'user_profile_cubit.dart';

abstract class AppUserProfileState extends Equatable {}

class UserInitial extends AppUserProfileState {
  @override
  List<Object?> get props => ['UserInitial'];
}

class UserInvalidRole extends AppUserProfileState {
  @override
  List<Object?> get props => [];
}

class UserFetchProfileInProgress extends AppUserProfileState {
  @override
  List<Object?> get props => ['UserFetchProfileInProgress'];
}

class UserFetchProfileSuccess extends AppUserProfileState {
  final String firstName;

  UserFetchProfileSuccess(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class UserFetchProfileError extends AppUserProfileState {
  final String msg;

  UserFetchProfileError(this.msg);

  @override
  List<Object?> get props => ['UserFetchProfileSuccess'];
}

class UserChangePasswordSuccess extends AppUserProfileState {
  @override
  List<Object?> get props => [UserChangePasswordSuccess];
}

class UserChangePasswordError extends AppUserProfileState {
  final String message;

  UserChangePasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppUserSendFeedbackInProgress extends AppUserProfileState {
  @override
  List<Object?> get props => ['AppUserProfileSendFeedbackInProgress'];
}

class AppUserSendFeedbackSuccess extends AppUserProfileState {
  @override
  List<Object?> get props => ['AppUserProfileSendFeedbackSuccess'];
}

class AppUserSendFeedbackError extends AppUserProfileState {
  final String message;

  AppUserSendFeedbackError(this.message);

  @override
  List<Object?> get props => [message];
}
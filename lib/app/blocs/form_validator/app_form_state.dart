part of 'app_form_cubit.dart';

@immutable
abstract class AppFormState {}

class AppFormInitial extends AppFormState {}

class AppFormEmailFormat extends AppFormState {
  final bool isValid;

  AppFormEmailFormat(this.isValid);
}

class AppFormEmailRequired extends AppFormState {}

class AppFormPasswordRequired extends AppFormState {}

class AppFormCodeRequired extends AppFormState {}

class AppFormPasswordNotMatch extends AppFormState {}

class AppFormValidateForgotChangePassword extends AppFormState {
  final bool isCodeValid;
  final bool isPasswordValid;
  final bool isConfirmValid;

  AppFormValidateForgotChangePassword(
    this.isCodeValid,
    this.isPasswordValid,
    this.isConfirmValid,
  );
}

class AppFormPasswordFormat extends AppFormState {
  final bool isValid;

  AppFormPasswordFormat(this.isValid);
}

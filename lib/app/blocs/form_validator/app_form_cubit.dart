import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_form_state.dart';

class AppFormCubit extends Cubit<AppFormState> {
  AppFormCubit() : super(AppFormInitial());

  final _emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
  final _passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  bool validateEmail(String email) {
    bool isValid = false;
    if (email != '') {
      isValid = _emailRegex.hasMatch(email);
      emit(AppFormEmailFormat(isValid));
    } else {
      emit(AppFormEmailRequired());
    }
    return isValid;
  }

  bool validateNewPassword(String password) {
    bool isValid = false;
    if (password.length > 7) {
      isValid = _passwordRegex.hasMatch(password);
    }
    emit(AppFormPasswordFormat(isValid));
    return isValid;
  }

  clearValidate() {
    emit(AppFormInitial());
  }

  bool validateCurrentPassword(String password) {
    bool isValid = password != '';
    if(isValid) {
      emit(AppFormInitial());
    } else {
      emit(AppFormPasswordRequired());
    }
    return isValid;
  }

  validateLoginPassword(String? password) {
    bool isValid = false;
    if (password != null) {
      isValid = password.length > 7;
    }
    emit(AppFormPasswordFormat(isValid));
  }

  bool isMatchPassword(String password, String confirm) {
    bool isMatch = password == confirm;
    if (!isMatch) {
      emit(AppFormPasswordNotMatch());
    }
    return isMatch;
  }

  bool validateConfirmForgotPasswordForm(
    String code,
    String password,
    String confirm,
  ) {
    bool isValidCode = validateCode(code),
        isValidPassword = validateNewPassword(password),
        isValidConfirm = isMatchPassword(password, confirm);
    emit(AppFormValidateForgotChangePassword(
      isValidCode,
      isValidPassword,
      isValidConfirm,
    ));
    return isValidCode && isValidPassword && isValidConfirm;
  }

  bool validateChangePasswordForm(
      String current,
      String password,
      String confirm,
      ) {
    bool isValidCurrent = validateCurrentPassword(current),
        isValidPassword = validateNewPassword(password),
        isValidConfirm = isMatchPassword(password, confirm);
    emit(AppFormValidateForgotChangePassword(
      isValidCurrent,
      isValidPassword,
      isValidConfirm,
    ));
    return isValidCurrent && isValidPassword && isValidConfirm;
  }

  bool validateCode(String code) {
    if(code == '') {
      emit(AppFormCodeRequired());
    } else {
      emit(AppFormInitial());
    }
    return code != '';
  }
}

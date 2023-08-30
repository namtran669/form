import 'package:flutter/widgets.dart';

import 'language_en.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages) ?? LanguageEn();
  }

  String get appName;

  String get home;

  String get treatment;

  String get chat;

  String get newFeed;

  String get user;

  String get location;

  String get signIntoTalosix;

  String get email;

  String get enterYourEmailAddress;

  String get enterYourPassword;

  String get password;

  String get enterEmailAddress;

  String get enterPassword;

  String get createAnewPassword;

  String get confirmPassword;

  String get currentPassword;

  String get newPassword;

  String get forgotYourPassword;

  String get forgotYourPasswordGuide;

  String get confirmForgotPasswordGuide;

  String get resetPassword;

  String get selectAuthenticationMethod;

  String get goingForward;

  String get enterYourPhoneNumber;

  String get verifyYourMobilePhone;

  String get verifyYourEmailAddress;

  String get verificationCode;

  String get twoFactorAuthenticationVerified;

  String get authenticateYourAccount;

  String get enterTheSixDigit;

  String get errorOtpInvalid;

  String get errorCannotLogin;

  String get patients;

  String get profile;

  String get code;

  String get inputVerificationCodeGuide;

  String get verificationCodeSuccessMessage;

  String get forgotPasswordSuccess;

  String get invalidAccountPermission;

  String get queryManagement;

  String get query;
}

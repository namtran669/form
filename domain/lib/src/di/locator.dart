import 'package:get_it/get_it.dart';

import '../../domain.dart';

final locator = GetIt.instance..allowReassignment = true;

void setupLocator() {
  /// Use case
  locator.registerFactory(() => SignIn(locator<AuthenticationRepo>()));
  locator.registerFactory(() => SignOut(locator<AuthenticationRepo>()));
  locator.registerFactory(() => FetchSession(locator<AuthenticationRepo>()));
  locator.registerFactory(() => ConfirmAccount(locator<AuthenticationRepo>()));
  locator.registerFactory(() => ConfirmSignIn(locator<AuthenticationRepo>()));

  locator.registerFactory(() => GetUserData(locator<UserDataRepo>()));
  locator.registerFactory(() => SettingMfa(locator<MfaRepo>()));
  locator.registerFactory(() => RequestOtpVerificationChallenge(locator<MfaRepo>()));
  locator.registerFactory(() => FetchUserProfile(locator<UserDataRepo>()));
  locator.registerFactory(() => RequestOtpAuthResend(locator<AuthenticationRepo>()));
}

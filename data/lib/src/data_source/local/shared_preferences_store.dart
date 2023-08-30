import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SharedPrefsStore {
  final FlutterSecureStorage _prefs;

  SharedPrefsStore(this._prefs);

  Future<void> saveUserData(AppUserData user) async {
    await saveDisplayedOnboardScreen();
    await _prefs.write(
        key: PreferencesKey.USER_DATA,
        value: jsonEncode(user.toJson()));
  }

  Future<String> getUserDataJson() async {
    return await _prefs.read(key: PreferencesKey.USER_DATA) ?? '';
  }

  Future<bool> hasUserData() async {
    return await _prefs.read(key: PreferencesKey.USER_DATA) != null;
  }

  Future<void> setInt(String key, int value) async {
    return await _prefs.write(key: key, value: value.toString());
  }

  Future<String> getSessionID() async {
    return await _prefs.read(key: PreferencesKey.SESSION_ID) as String;
  }

  Future<bool> isFirstTimeLogin() async {
    bool isDisplayedOnboardScreen = await _prefs.containsKey(key: PreferencesKey.IS_DISPLAYED_ONBOARD_SCREEN);
    return !isDisplayedOnboardScreen;
  }

  Future<void> saveDisplayedOnboardScreen() async {
    return await _prefs.write(key: PreferencesKey.IS_DISPLAYED_ONBOARD_SCREEN, value: 'true');
  }

  void clearUserData() async {
   await _prefs.deleteAll();
  }
}

class PreferencesKey {
  static const String REGION = 'REGION';
  static const String USER_DATA = 'USER_DATA';
  static const String SESSION_ID = 'SESSION_ID';
  static const String IS_DISPLAYED_ONBOARD_SCREEN = 'IS_DISPLAYED_ONBOARD_SCREEN';
}

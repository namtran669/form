
import 'dart:convert';

import 'package:domain/domain.dart';

class AppUserDataModel extends AppUserData {

  static final AppUserDataModel _singleton = AppUserDataModel._internal();

  factory AppUserDataModel() {
    return _singleton;
  }

  AppUserDataModel._internal();

  factory AppUserDataModel.fromJson(Map<String, dynamic> json) {
    AppUserDataModel userDataModel = AppUserDataModel();
    userDataModel.accessToken = json['accessToken'];
    userDataModel.refreshToken = json['refreshToken'];
    userDataModel.signInStep = json['signInStep'];
    userDataModel.sessionId = json['sessionId'];
    userDataModel.firstName = json['firstName'];
    userDataModel.lastName = json['lastName'];
    userDataModel.roleName = json['roleName'];
    return userDataModel;
  }

  factory AppUserDataModel.fromJsonString(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return AppUserDataModel.fromJson(json);
  }
}
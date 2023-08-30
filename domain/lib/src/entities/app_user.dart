import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(
  checked: true
)
class AppUserData {
  String? accessToken;
  String? refreshToken;
  String? signInStep;
  String? mfaOption;
  String? email;
  String? phone;
  String? loginSession;
  String? userEmail;
  String? sessionId;
  String? internalToken;
  String? userId;
  String? firstName;
  String? lastName;
  String? roleShortName;
  String? roleName;
  int? roleId;

  AppUserData();

  Map<String, dynamic> toJson() {
    return {
      'signInStep': signInStep,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'loginSession': loginSession,
      'sessionId': sessionId,
      'internalToken': internalToken,
      'firstName': firstName,
      'lastName': lastName,
      'roleShortName': roleShortName,
      'roleName': roleName,
    };
  }

  @override
  String toString() {
    return '$firstName - $lastName';
  }
}

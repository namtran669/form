import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';

import '../constants/firestore_constants.dart';

class UserChat {
  String id;
  String avatarUri;
  String avatarUrl;
  String? nickname;
  String? userRole;
  bool isOnline;
  String email;

  UserChat({
    required this.id,
    required this.avatarUri,
    required this.avatarUrl,
    required this.nickname,
    required this.userRole,
    required this.isOnline,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'userRole': userRole,
      FirestoreField.avatarUri: avatarUri,
      FirestoreField.avatarUrl: avatarUrl,
      FirestoreField.isOnline: isOnline,
      FirestoreField.email: email,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String userRole = '';
    String avatarUri = '';
    String avatarUrl = '';
    String nickname = '';
    bool isOnline = false;
    String email = '';
    try {
      avatarUri = doc.get(FirestoreField.avatarUri);
    } catch (_) {}
    try {
      avatarUrl = doc.get(FirestoreField.avatarUrl);
    } catch (_) {}
    try {
      isOnline = doc.get(FirestoreField.isOnline);
    } catch (_) {}
    try {
      email = doc.get(FirestoreField.email);
    } catch (_) {}
    return UserChat(
      id: doc.id,
      avatarUri: avatarUri,
      avatarUrl: avatarUrl,
      nickname: nickname,
      userRole: userRole,
      isOnline: isOnline,
      email: email,
    );
  }

  UserChat getFullInformation(AppUserData edcUser) {
    nickname = '${edcUser.firstName} ${edcUser.lastName}';
    userRole = _getUserRoleName(edcUser.roleId);
    return this;
  }

  String _getUserRoleName(int? roleId) {
    switch(roleId) {
      case 1:
        return 'Talosix Administrator';
      case 2:
        return 'Application Manager';
      case 3:
        return 'Study Manager';
      case 4:
        return 'Study Form Creator';
      case 5:
        return 'PRO Data Entry';
      case 6:
        return 'Site/Clinic Admin';
      case 7:
        return 'Site/Clinic User';
      case 8:
        return '3rd-Party/Contractor';
      case 9:
        return 'Physician';
      case 10:
        return 'Industry Client';
      case 11:
        return 'Patients / Caregivers';
      case 12:
        return 'Monitor';
      case 13:
        return 'Reading Radiologist';
      case 14:
        return 'Principal Investigator';
      case 15:
        return 'Remote Clinician';
      default:
        return '';
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firestore_constants.dart';

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;

  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreField.idFrom: idFrom,
      FirestoreField.idTo: idTo,
      FirestoreField.timestamp: timestamp,
      FirestoreField.content: content,
      FirestoreField.type: type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreField.idFrom);
    String idTo = doc.get(FirestoreField.idTo);
    String timestamp = doc.get(FirestoreField.timestamp);
    String content = doc.get(FirestoreField.content);
    int type = doc.get(FirestoreField.type);
    return MessageChat(
      idFrom: idFrom,
      idTo: idTo,
      timestamp: timestamp,
      content: content,
      type: type,
    );
  }
}

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talosix/chat/models/user_chat.dart';

import '../../../chat/constants/firestore_constants.dart';
import '../../../chat/models/message_chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final PatientDocumentRepo patientDocumentRepo;
  final TelehealthRepo telehealthRepo;

  final AppUserDataModel appUserDataModel = AppUserDataModel();
  final int _limit = 10000;
  final List<AppUserData> _contacts = [];
  final Map<String, String> _imagesMap = {};
  final Map<String, dynamic> _senderNewMessageMap = {};

  User? firebaseUser;
  UserChat? userChat;

  ChatCubit({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.patientDocumentRepo,
    required this.telehealthRepo,
  }) : super(ChatInitial());

  loadInitialData() async {
    try {
      final QuerySnapshot<Object?> snapshot = await firebaseFirestore
          .collection(FirestoreCollection.users)
          .limit(_limit)
          .get();
      final List<QueryDocumentSnapshot<Object?>> docs = snapshot.docs;
      emit(ChatLoaded(docs: docs));
    } catch (e) {
      emit(ChatError());
    }
  }

  String getCurrentUserFirebaseId() {
    return firebaseUser?.uid ?? '';
  }

  Future loginFirebase() async {
    String defaultPassword = 'QWEasdzxc!@#11223344';
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: appUserDataModel.email!,
        password: defaultPassword,
      );
    } catch (_) {}

    UserCredential? loginResult;
    try {
      loginResult = await firebaseAuth.signInWithEmailAndPassword(
        email: appUserDataModel.email!,
        password: defaultPassword,
      );
    } catch (_) {}

    if (loginResult == null || loginResult.user == null) {
      emit(ChatAuthLoggedOut());
      return;
    }

    _fetchContactList();
    firebaseUser = loginResult.user;
    final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreCollection.users)
        .where(FirestoreField.id, isEqualTo: firebaseUser!.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      _createFirebaseUserData();
    } else {
      _setChatUserIsOnline(true);
    }
    _createUserChat();
    emit(ChatAuthLoggedIn());
  }

  _createUserChat() async {
    final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreCollection.users)
        .where(FirestoreField.id, isEqualTo: firebaseUser!.uid)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    userChat = UserChat.fromDocument(documents.first);
  }

  Future logoutFirebase() async {
    await _setChatUserIsOnline(false);
    await firebaseAuth.signOut();
    emit(ChatAuthLoggedOut());
  }

  Future updateDataFirestore(
    String collectionPath,
    Map<String, dynamic> dataNeedUpdate,
  ) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(getCurrentUserFirebaseId())
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getStreamUsers(
    String? textSearch,
  ) {
    if (textSearch != null && textSearch.isNotEmpty) {
      return firebaseFirestore
          .collection(FirestoreCollection.users)
          .limit(_limit)
          // .where(FirestoreConstants.nickname, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(FirestoreCollection.users)
          .limit(_limit)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getStreamUserById(String firebaseUserId) {
    return firebaseFirestore
        .collection(FirestoreCollection.users)
        .limit(1)
        .where(FirestoreField.id, isEqualTo: firebaseUserId)
        .snapshots();
  }

  Future<String> uploadFile(String key, File file) async {
    String fileURI = '';
    String fileName = file.path.split('/').last;
    var result = await patientDocumentRepo.uploadImage(
      '$key/$fileName',
      'application/octet-stream',
      file,
    );
    result.when(
      success: (fieldData) {
        fileURI = fieldData['key'];
      },
    );
    return fileURI;
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId) {
    return firebaseFirestore
        .collection(FirestoreCollection.messages)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreField.timestamp, descending: true)
        .limit(_limit)
        .snapshots();
  }

  Future sendMessage(
    String content,
    int type,
    String groupChatId,
    String senderId,
    String peerId,
  ) async {
    DocumentReference messageDR = firebaseFirestore
        .collection(FirestoreCollection.messages)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: senderId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    await firebaseFirestore.runTransaction((transaction) async {
      transaction.set(
        messageDR,
        messageChat.toJson(),
      );
    });

    _setNewMessageStatus(senderId, peerId);
  }

  bool isLoggedInFirebase() {
    return firebaseAuth.currentUser != null;
  }

  _setNewMessageStatus(String senderId, String peerId) async {
    Map<String, dynamic> senderMap =
        await _fetchSenderNewMessageMapById(peerId);
    senderMap[senderId] = true;
    firebaseFirestore
        .collection(FirestoreCollection.users)
        .doc(peerId)
        .update({FirestoreField.senderNewMessages: senderMap});
  }

  setReadMessageStatus(String peerId) async {
    _senderNewMessageMap[peerId] = false;
    firebaseFirestore
        .collection(FirestoreCollection.users)
        .doc(getCurrentUserFirebaseId())
        .update({FirestoreField.senderNewMessages: _senderNewMessageMap});
  }

  fetchCurrentUserSenderNewMessageMap() async {
    Map<String, dynamic> sender = await _fetchSenderNewMessageMapById(
      getCurrentUserFirebaseId(),
    );
    _senderNewMessageMap
      ..clear()
      ..addAll(sender);
  }

  bool isHasNewMessage(String peerId) {
    return _senderNewMessageMap[peerId] ?? false;
  }

  Future<Map<String, dynamic>> _fetchSenderNewMessageMapById(String id) async {
    final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreCollection.users)
        .where(FirestoreField.id, isEqualTo: id)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isNotEmpty) {
      try {
        return documents.first.get(FirestoreField.senderNewMessages);
      } catch (_) {}
    }
    return {};
  }

  downloadImageChat(String uriImage) async {
    emit(ChatImageDownloadLoading());
    if (_imagesMap.containsKey(uriImage)) {
      emit(ChatImageDownloadLoaded(_imagesMap));
      return;
    }

    var result = await patientDocumentRepo.downloadUrl([uriImage]);
    result.when(success: (data) {
      _imagesMap[uriImage] = data[0]['url'];
      emit(ChatImageDownloadLoaded(_imagesMap));
    }, error: (e) {
      emit(ChatImageDownloadError());
    });
  }

  _setChatUserIsOnline(bool isOnline) {
    updateDataFirestore(
      FirestoreCollection.users,
      {FirestoreField.isOnline: isOnline},
    );
  }

  _createFirebaseUserData() {
    // Writing data to server because here is a new user
    String createTime = DateTime.now().millisecondsSinceEpoch.toString();
    firebaseFirestore
        .collection(FirestoreCollection.users)
        .doc(firebaseUser!.uid)
        .set({
      FirestoreField.avatarUri: null,
      FirestoreField.id: firebaseUser!.uid,
      FirestoreField.createAt: createTime,
      FirestoreField.chattingWith: null,
      FirestoreField.isOnline: true,
      FirestoreField.email: appUserDataModel.email,
    });
  }

  _fetchContactList() async {
    var contactResult = await telehealthRepo.fetchContactList();
    contactResult.when(success: (contacts) {
      _contacts
        ..clear()
        ..addAll(contacts);
    });
  }

  List<AppUserData> getContactList() {
    return _contacts;
  }

  fetchAvatar() async {
    if (userChat?.avatarUri != null) {
      emit(ChatAvatarLoading());
      var result = await patientDocumentRepo.downloadUrl([userChat!.avatarUri]);
      result.when(success: (data) {
        userChat?.avatarUrl = data[0]['url'];
        updateDataFirestore(
          FirestoreCollection.users,
          {FirestoreField.avatarUrl: userChat?.avatarUrl},
        );
        emit(ChatAvatarLoaded(userChat!.avatarUrl));
      });
    } else {
      emit(ChatAvatarNotAvailable());
    }
  }

  uploadAvatar(XFile file) async {
    emit(ChatAvatarUploading());
    String avatarUri = await uploadFile('avatars', File(file.path));
    updateDataFirestore(
      FirestoreCollection.users,
      {FirestoreField.avatarUri: avatarUri},
    );
    var result = await patientDocumentRepo.downloadUrl([avatarUri]);
    result.when(success: (data) {
      userChat?.avatarUrl = data[0]['url'];
      updateDataFirestore(
        FirestoreCollection.users,
        {FirestoreField.avatarUrl: userChat?.avatarUrl},
      );
      emit(ChatAvatarLoaded(userChat!.avatarUrl));
    });
  }
}

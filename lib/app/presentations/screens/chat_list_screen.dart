import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:talosix/app/blocs/chat/chat_cubit.dart';
import 'package:talosix/app/constants/app_images.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/screens/chat_details_screen.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../chat/constants/firestore_constants.dart';
import '../../../chat/models/user_chat.dart';
import '../../constants/app_colors.dart';
import '../../styles/app_styles.dart';
import '../../util/debounce.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  _ChatListScreenState({Key? key});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  final bool _isLoading = false;

  late ChatCubit chatCubit;
  Debounce searchDebounce = Debounce(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTC = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatCubit = context.read<ChatCubit>();
    _registerNotification();
    _configLocalNotification();
    listScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  _registerNotification() {
    firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      if (token != null) {
        chatCubit.updateDataFirestore(
          FirestoreCollection.users,
          {'pushToken': token},
        );
      }
    }).catchError((err) {});
  }

  _configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {});
    }
  }

  _showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid ? 't6.mobile.talosix' : 't6.mobile.edc',
      'DataFlow Telehealth',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        const IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  _checkUserStatus() async {
    if (!chatCubit.isLoggedInFirebase()) {
      await chatCubit.loginFirebase();
    }
  }

  @override
  Widget build(BuildContext context) {
    chatCubit.fetchCurrentUserSenderNewMessageMap();
    return VisibilityDetector(
      key: const Key('ChatScreen'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          _checkUserStatus();
          chatCubit.loadInitialData();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              // List
              Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: chatCubit.getStreamUsers(searchBarTC.text),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if ((snapshot.data?.docs.length ?? 0) > 0) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemBuilder: (context, index) => _buildItem(
                                context,
                                snapshot.data?.docs[index],
                              ),
                              itemCount: snapshot.data?.docs.length,
                              controller: listScrollController,
                            );
                          } else {
                            return const Center(
                              child: Text('No users'),
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                child: _isLoading ? const LoadingView() : emptyBox,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.dustyGray.withOpacity(0.3),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: AppColors.dustyGray.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTC,
              onChanged: (value) {
                searchDebounce.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {});
                  } else {
                    btnClearController.add(false);
                    setState(() {});
                  }
                });
              },
              decoration: InputDecoration.collapsed(
                  hintText: 'Search nickname (you have to type exactly string)',
                  hintStyle: AppTextStyles.w400s15dustyGrey06),
              style: AppTextStyles.w400s15black,
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTC.clear();
                          btnClearController.add(false);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.white,
                          size: 20,
                        ))
                    : emptyBox;
              }),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document == null) return emptyBox;
    UserChat userChat = UserChat.fromDocument(document);
    if (userChat.id == chatCubit.getCurrentUserFirebaseId()) return emptyBox;
    List<AppUserData> contacts = context.read<ChatCubit>().getContactList();
    AppUserData? edcUser = _findUserDataByEmail(contacts, userChat.email);
    if (edcUser == null) return emptyBox;

    userChat = userChat.getFullInformation(edcUser);
    String username = userChat.nickname ?? '';
    String role = userChat.userRole ?? '';
    bool isNewMessage = chatCubit.isHasNewMessage(userChat.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: TextButton(
        onPressed: () {
          if (context.isKeyboardShowing()) {
            context.closeKeyboard();
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailsScreen(
                arguments: ChatPageArguments(
                  peerId: userChat.id,
                  peerAvatar: userChat.avatarUrl,
                  peerNickname: username,
                ),
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              AppColors.dustyGray.withOpacity(0.3)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Stack(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                  child: userChat.avatarUri.isNotEmpty
                      ? Image.network(userChat.avatarUrl,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.dodgerBlue,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => defaultAvatar)
                      : defaultAvatar,
                ),
                userChat.isOnline
                    ? Positioned(
                        bottom: 0,
                        right: 0,
                        child: statusOnline,
                      )
                    : emptyBox
              ],
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 10, bottom: 5),
                            child: Text(
                              username,
                              maxLines: 1,
                              style: isNewMessage
                                  ? AppTextStyles.w600s15black
                                  : AppTextStyles.w400s15black,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              role,
                              maxLines: 1,
                              style: AppTextStyles.w400s15deepSapphire,
                            ),
                          )
                        ],
                      ),
                    ),
                    isNewMessage
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 5,
                            ),
                            child: statusNewMessage,
                          )
                        : emptyBox
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppUserData? _findUserDataByEmail(List<AppUserData> contacts, String email) {
    AppUserData? edcUser;
    for (var contact in contacts) {
      if (contact.email == email) {
        edcUser = contact;
      }
    }
    return edcUser;
  }
}

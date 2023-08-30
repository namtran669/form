import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:talosix/app/blocs/chat/chat_cubit.dart';
import 'package:talosix/app/constants/app_images.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';
import 'package:talosix/app/presentations/widgets/custom_webview.dart';

import '../../../chat/constants/firestore_constants.dart';
import '../../../chat/models/message_chat.dart';
import '../../constants/app_colors.dart';
import '../../extensions/context_ext.dart';
import '../../styles/app_styles.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({Key? key, required this.arguments})
      : super(key: key);

  final ChatPageArguments arguments;

  @override
  State createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  late String currentUserId;
  late ChatCubit chatCubit;

  List<QueryDocumentSnapshot> listMessage = [];
  String groupChatId = '';
  bool isLoading = false;
  int messageQuantity = 1000;
  double avatarSize = 50;
  double imageChatSize = 200;

  final Map<String, String> mapImages = {};
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatCubit = context.read<ChatCubit>();
    listScrollController.addListener(_scrollListener);
    _readLocal();
  }

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        messageQuantity <= listMessage.length) {
      setState(() {
        messageQuantity += messageQuantity;
      });
    }
  }

  _readLocal() {
    currentUserId = chatCubit.getCurrentUserFirebaseId();
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    chatCubit.updateDataFirestore(
      FirestoreCollection.users,
      {FirestoreField.chattingWith: peerId},
    );
  }

  Future _getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? imageFile = File(pickedFile.path);
      setState(() {
        isLoading = true;
      });

      //Upload image
      String fileURI = await chatCubit.uploadFile('chats', imageFile);
      await chatCubit.downloadImageChat(fileURI);
      try {
        setState(() {
          isLoading = false;
          _onSendMessage(fileURI, _ChatMessageType.image);
        });
      } on FirebaseException {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  _onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatCubit.sendMessage(
        content,
        type,
        groupChatId,
        currentUserId,
        widget.arguments.peerId,
      );
      if (listScrollController.hasClients) {
        listScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } else {
      context.showMessage(ToastMessageType.error, 'Content is blank');
    }
  }

  bool _isLastMessageLeft(int index) {
    return (index > 0 &&
            listMessage[index - 1].get(FirestoreField.idFrom) ==
                currentUserId) ||
        index == 0;
  }

  bool _isLastMessageRight(int index) {
    return (index > 0 &&
            listMessage[index - 1].get(FirestoreField.idFrom) !=
                currentUserId) ||
        index == 0;
  }

  Future<bool> _onBackPress() {
    chatCubit.updateDataFirestore(
      FirestoreCollection.users,
      {FirestoreField.chattingWith: ''},
    );
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    chatCubit.setReadMessageStatus(widget.arguments.peerId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                widget.arguments.peerNickname,
                style: AppTextStyles.w500s18holly,
              ),
            ),
            const SizedBox(width: 8),
            StreamBuilder<QuerySnapshot>(
              stream: chatCubit.getStreamUserById(widget.arguments.peerId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.size == 0) {
                  return emptyBox;
                }
                return _buildUserStatus(snapshot.data?.docs[0]);
              },
            )
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPress,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  _buildListMessage(),
                  // Input content
                  _buildInput(),
                ],
              ),
              // Loading
              _buildLoading()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Positioned(
      child: isLoading ? const LoadingView() : emptyBox,
    );
  }

  Widget _buildInput() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
            color: AppColors.dustyGray,
            width: 0.5,
          )),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: _getImage,
                color: AppColors.dodgerBlue,
              ),
            ),
          ),
          // Edit text
          Flexible(
            child: TextField(
              onSubmitted: (value) {
                _onSendMessage(
                    textEditingController.text, _ChatMessageType.text);
              },
              style: AppTextStyles.w400s15black,
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: AppColors.dustyGray),
              ),
              autofocus: true,
            ),
          ),

          // Button send message
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _onSendMessage(
                  textEditingController.text,
                  _ChatMessageType.text,
                ),
                color: AppColors.dodgerBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatCubit.getChatStream(groupChatId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isEmpty) {
                    return const Center(child: Text('No message here yet...'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) =>
                        _buildItem(index, snapshot.data?.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.dodgerBlue,
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.dodgerBlue,
              ),
            ),
    );
  }

  Widget _buildItem(int index, DocumentSnapshot? document) {
    if (document == null) return emptyBox;
    MessageChat messageChat = MessageChat.fromDocument(document);
    if (messageChat.type == _ChatMessageType.image) {
      chatCubit.downloadImageChat(messageChat.content);
    }
    return messageChat.idFrom == currentUserId
        ? _buildRightMessage(index, messageChat)
        : _buildLeftMessage(index, messageChat);
  }

  Widget _buildRightMessage(int index, MessageChat messageChat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        messageChat.type == _ChatMessageType.text
            ? _buildRightTextMessage(index, messageChat)
            : messageChat.type == _ChatMessageType.image
                ? _buildRightImageMessage(index, messageChat)
                : emptyBox,
      ],
    );
  }

  Widget _buildLeftMessage(int index, MessageChat messageChat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _isLastMessageLeft(index)
                  ? _buildPeerAvatar(widget.arguments.peerAvatar)
                  : Container(width: 35),
              messageChat.type == _ChatMessageType.text
                  ? _buildLeftTextMessage(index, messageChat)
                  : messageChat.type == _ChatMessageType.image
                      ? _buildLeftImageMessage(index, messageChat)
                      : emptyBox
            ],
          ),
          _isLastMessageLeft(index)
              ? _buildMessageTime(int.parse(messageChat.timestamp))
              : emptyBox
        ],
      ),
    );
  }

  Widget _buildRightTextMessage(int index, MessageChat messageChat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.deepSapphire,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(
        bottom: _isLastMessageRight(index) ? 20 : 10,
        right: 10,
      ),
      child: Text(
        messageChat.content,
        style: const TextStyle(color: AppColors.eggWhite),
      ),
    );
  }

  Widget _buildRightImageMessage(int index, MessageChat messageChat) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatImageDownloadLoaded) {
          mapImages
            ..clear()
            ..addAll(state.mapImageUrls);
        }

        String imageUrl = mapImages[messageChat.content] ?? '';
        return Container(
          margin: EdgeInsets.only(
            bottom: _isLastMessageRight(index) ? 20 : 10,
            right: 10,
          ),
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomWebView(
                    url: imageUrl,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(0),
              ),
            ),
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                imageUrl,
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColors.dustyGray,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    width: imageChatSize,
                    height: imageChatSize,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.dustyGray,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, object, stackTrace) {
                  return Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      AppImages.imgNotAvailable,
                      width: imageChatSize,
                      height: imageChatSize,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                width: imageChatSize,
                height: imageChatSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftTextMessage(int index, MessageChat messageChat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.dustyGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(left: 10),
      child: Text(
        messageChat.content,
        style: const TextStyle(color: AppColors.deepSapphire),
      ),
    );
  }

  Widget _buildLeftImageMessage(int index, MessageChat messageChat) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatImageDownloadLoaded) {
          mapImages
            ..clear()
            ..addAll(state.mapImageUrls);
        }
        String imageUrl = mapImages[messageChat.content] ?? '';
        return Container(
          margin: const EdgeInsets.only(left: 10),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomWebView(url: imageUrl),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(0),
              ),
            ),
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                imageUrl,
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColors.dustyGray,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    width: imageChatSize,
                    height: imageChatSize,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.dustyGray,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, object, stackTrace) {
                  return Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      AppImages.imgNotAvailable,
                      width: imageChatSize,
                      height: imageChatSize,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                width: imageChatSize,
                height: imageChatSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeerAvatar(String peerAvatar) {
    return Material(
      borderRadius: const BorderRadius.all(
        Radius.circular(18),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.network(
        peerAvatar,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.dustyGray,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, object, stackTrace) => defaultAvatar,
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildMessageTime(int timestamp) {
    return Container(
      margin: const EdgeInsets.only(
        left: 50,
        top: 5,
        bottom: 5,
      ),
      child: Text(
        DateFormat('dd MMM kk:mm').format(
          DateTime.fromMillisecondsSinceEpoch(timestamp),
        ),
        style: AppTextStyles.w400s12grey500Italic,
      ),
    );
  }

  Widget _buildUserStatus(DocumentSnapshot? document) {
    try {
      bool isOnline = document?.get(FirestoreField.isOnline);
      if (isOnline) {
        return statusOnline;
      }
    } catch (_) {}
    return emptyBox;
  }
}

class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(
      {required this.peerId,
      required this.peerAvatar,
      required this.peerNickname});
}

class _ChatMessageType {
  static const text = 0;
  static const image = 1;
}

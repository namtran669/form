
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talosix/app/blocs/chat/chat_cubit.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';
import 'package:talosix/app/presentations/widgets/custom_webview.dart';

import '../../constants/app_colors.dart';
import '../../styles/app_styles.dart';

class UpdateYourAvatarScreen extends StatefulWidget {
  const UpdateYourAvatarScreen({Key? key}) : super(key: key);


  @override
  State<UpdateYourAvatarScreen> createState() => _UpdateYourAvatarScreenState();
}

class _UpdateYourAvatarScreenState extends State<UpdateYourAvatarScreen> {
  final double avatarScreenSize = 1800;

  @override
  Widget build(BuildContext context) {
    ChatCubit chatCubit = context.read<ChatCubit>();
    chatCubit.fetchAvatar();
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Update Your Avatar',
          style: AppTextStyles.w500s18holly,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 280,
            child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
              if (state is ChatAvatarUploading || state is ChatAvatarUploading) {
                return const Center(child: CircularProgressIndicator());
              } else  if(state is ChatAvatarLoaded) {
                return CustomWebView(url: state.avatarLink);
              } else if(state is ChatAvatarNotAvailable) {
                return const Center(child: Text('Please submit your new avatar.'));
              }
              return emptyBox;
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ElevatedButton(
                onPressed: () => _showActions(),
                style: AppButtonStyles.r40blueDodger,
                child: const Center(
                  child: Text(
                    'Update',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showActions() {
    showAdaptiveActionSheet(
      context: context,
      title: const Text(
        'Choose Your Avatar',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      actions: [
        BottomSheetAction(
          title: Row(
            children: const [
              Icon(Icons.camera_alt_outlined, size: 20),
              SizedBox(width: 13),
              Text(
                'Use Camera',
                style: AppTextStyles.w400s16black,
              ),
            ],
          ),
          onPressed: (_) {
            _getFromCamera();
            Navigator.of(context).pop();
          },
        ),
        BottomSheetAction(
          title: Row(
            children: const [
              Icon(Icons.photo_library_outlined, size: 20),
              SizedBox(width: 13),
              Text(
                'From Photos Library',
                style: AppTextStyles.w400s16black,
              ),
            ],
          ),
          onPressed: (_) {
            _getFromGallery();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: avatarScreenSize,
      maxHeight: avatarScreenSize,
    );
    if (pickedFile != null) {
      _uploadAvatar(pickedFile);
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: avatarScreenSize,
      maxHeight: avatarScreenSize,
    );

    if (pickedFile != null) {
      _uploadAvatar(pickedFile);
    }
  }

  _uploadAvatar(XFile pickedFile) {
    context.read<ChatCubit>().uploadAvatar(pickedFile);
  }
}

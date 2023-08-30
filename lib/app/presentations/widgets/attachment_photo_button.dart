import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:camera/camera.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talosix/app/extensions/context_ext.dart';

import '../../blocs/form_question/form_detail_cubit.dart';
import '../../blocs/patient_document/patient_document_cubit.dart';
import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../screens/preview_patient_document_screen.dart';
import 'common_view.dart';
import 'dart:io';

class AttachmentPhotoButton extends StatefulWidget {
  final String questionKey;

  const AttachmentPhotoButton({
    Key? key,
    required this.questionKey,
  }) : super(key: key);

  @override
  State<AttachmentPhotoButton> createState() => _AttachmentPhotoButtonState();
}

class _AttachmentPhotoButtonState extends State<AttachmentPhotoButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientDocumentCubit, PatientDocumentState>(
      builder: (context, state) {
        var documentCubit = context.read<PatientDocumentCubit>();
        var formDetailCubit = context.read<FormDetailCubit>();

        if (state is PatientDocumentUploading &&
            state.questionKey == widget.questionKey) {
          return Container(
            padding: const EdgeInsets.all(5),
            width: 30,
            height: 30,
            child: const CircularProgressIndicator(),
          );
        }

        List<PatientDocument> attachedFiles = [];
        if (state is PatientDocumentAddSuccess) {
          //assign list documents for submit form data
          formDetailCubit.uploadedDocument = documentCubit.uploadedFiles;
          attachedFiles = state.uploadingDocument[widget.questionKey] ?? [];
        }
        bool hasAttachDoc = attachedFiles.isNotEmpty;

        return Row(
          children: [
            hasAttachDoc
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _listAttachedDocumentWidget(attachedFiles),
                  )
                : emptyBox,
            const Spacer(),
            GestureDetector(
              child: Image.asset(
                AppIcons.moreHorizontal,
                color: Colors.grey,
                width: 25,
                height: 25,
              ),
              onTap: () => _showActions(),
            ),
          ],
        );
      },
      listener: (context, state) {
        if (state is PatientDocumentError) {
          context.showMessage(ToastMessageType.error, state.errorMsg);
        } else if (state is PatientDocumentUploading) {
          if (widget.questionKey == state.questionKey) {
            context.showMessage(ToastMessageType.uploading, 'Uploading');
          }
        }
      },
    );
  }

  List<Widget> _listAttachedDocumentWidget(List<PatientDocument> documents) {
    List<Widget> widget = [];
    if (documents.isNotEmpty) {
      for (var document in documents) {
        String fileName = document.fileName.split('/').last;
        widget.add(const SizedBox(height: 3));
        widget.add(
          GestureDetector(
            onTap: () {
              PageRoute previewScreen;
              if (Platform.isAndroid) {
                previewScreen = MaterialPageRoute(
                  builder: (context) =>
                      PreviewPatientDocumentScreen(document: document),
                );
              } else {
                previewScreen = CupertinoPageRoute(
                  builder: (context) =>
                      PreviewPatientDocumentScreen(document: document),
                );
              }
              Navigator.of(context).push(previewScreen);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RotationTransition(
                  turns: AlwaysStoppedAnimation(30 / 360),
                  child: Icon(
                    Icons.attach_file_outlined,
                    size: 20,
                    color: AppColors.dodgerBlue,
                  ),
                ),
                Text(
                  fileName.length > 20 ? fileName.substring(0, 20) : fileName,
                  style: AppTextStyles.w400s14dodgerBlue,
                )
              ],
            ),
          ),
        );
      }
    }
    return widget;
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      _uploadFile(pickedFile);
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      _uploadFile(pickedFile);
    }
  }

  _uploadFile(XFile pickedFile) {
    var formDetailCubit = context.read<FormDetailCubit>();
    var patientDocumentCubit = context.read<PatientDocumentCubit>();

    String formId = formDetailCubit.formResponse!.id.toString();
    patientDocumentCubit.uploadFileByFormId(
      formId,
      widget.questionKey,
      File(pickedFile.path),
    );
  }

  _showActions() {
    showAdaptiveActionSheet(
      context: context,
      title: const Text(
        'Add Document',
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
}

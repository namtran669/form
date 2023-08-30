import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talosix/app/blocs/form_queries/form_queries_cubit.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/screens/preview_patient_document_screen.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';
import 'package:talosix/app/presentations/widgets/query_status_view.dart';

import '../../constants/app_colors.dart';
import '../../styles/app_styles.dart';
import '../../ui_model/form_query_status.dart';

class FormQueryDetailScreen extends StatefulWidget {
  const FormQueryDetailScreen({Key? key}) : super(key: key);

  @override
  State<FormQueryDetailScreen> createState() => _FormQueryDetailScreenState();
}

class _FormQueryDetailScreenState extends State<FormQueryDetailScreen> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var query = ModalRoute.of(context)!.settings.arguments as FormQueryDetails;
    var formQueriesCubit = context.read<FormQueriesCubit>();
    formQueriesCubit.fetchCommentsByQueriesId(query.id);

    const double space = 12;
    var status = FormQueryStatusExt.createFromString(query.status);

    return BlocListener<FormQueriesCubit, FormQueriesState>(
      listener: (context, state) {
        if (state is FormQueriesDownloadDocumentSuccess) {
          var attachment = PatientDocument();
          attachment.fileUrl = state.url;
          attachment.fileName = state.fileName;
          Navigator.of(context).push(_preview(attachment));
        } else if (state is FormQueriesDownloadDocumentError) {
          context.showMessage(ToastMessageType.error, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Query',
            style: AppTextStyles.w500s22black,
          ),
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              formQueriesCubit.refreshQueriesStatus();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QueryStatusView(
                        status: status,
                        verticalPadding: 5,
                        horizontalPadding: 30,
                        iconWidth: 20,
                        iconHeight: 20,
                        fontSize: 14,
                      ),
                      const SizedBox(height: space),
                      const Text(
                        'Created By',
                        style: AppTextStyles.w600s16black,
                      ),
                      const SizedBox(height: space),
                      Text(
                        query.createdByUser,
                        style: AppTextStyles.w400s16black,
                      ),
                      const SizedBox(height: space),
                      const Text(
                        'Assignee',
                        style: AppTextStyles.w600s16black,
                      ),
                      const SizedBox(height: space),
                      Text(
                        query.assignee,
                        style: AppTextStyles.w400s16black,
                      ),
                      const SizedBox(height: space),
                      const Text(
                        'Description',
                        style: AppTextStyles.w600s16black,
                      ),
                      const SizedBox(height: space),
                      Text(
                        query.description,
                        style: AppTextStyles.w400s16black,
                      ),
                      const SizedBox(height: space),
                      const Text(
                        'Question',
                        style: AppTextStyles.w600s16black,
                      ),
                      const SizedBox(height: space),
                      query.question,
                      const SizedBox(height: space),
                      const Text(
                        'Last Updated',
                        style: AppTextStyles.w600s16black,
                      ),
                      const SizedBox(height: space),
                      Text(
                        query.lastUpdated.replaceAll('T', ' ').split('.').first,
                        style: AppTextStyles.w400s16black,
                      ),
                      const SizedBox(height: space),
                      _CommentsSection(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1.0,
                    color: AppColors.hippieBlue.withOpacity(0.25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _inputCommentWidget(),
                      Divider(
                        height: 1,
                        thickness: 1.5,
                        color: AppColors.hippieBlue.withOpacity(0.25),
                      ),
                      const SizedBox(height: 8),
                      _sendCommentWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

  _uploadFile(XFile pickedFile) {
    var formQueriesCubit = context.read<FormQueriesCubit>();
    formQueriesCubit.uploadDocumentForQueryId(File(pickedFile.path));
  }

  PageRoute _preview(PatientDocument attachment) {
    PageRoute previewScreen;

    if (Platform.isAndroid) {
      previewScreen = MaterialPageRoute(
        builder: (context) =>
            PreviewPatientDocumentScreen(document: attachment),
      );
    } else {
      previewScreen = CupertinoPageRoute(
        builder: (context) =>
            PreviewPatientDocumentScreen(document: attachment),
      );
    }
    return previewScreen;
  }

  Widget _inputCommentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<FormQueriesCubit, FormQueriesState>(
        builder: (context, state) {
          if (state is FormQueriesCommentSuccess) {
            _commentController.clear();
          }
          return TextField(
            controller: _commentController,
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Add your comment...',
              hintStyle: AppTextStyles.w400s16grey,
            ),
            style: AppTextStyles.w400s16black,
          );
        },
      ),
    );
  }

  Widget _sendCommentWidget() {
    var formQueriesCubit = context.read<FormQueriesCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<FormQueriesCubit, FormQueriesState>(
            builder: (context, state) {
              if (state is FormQueriesAttachmentLoading) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                );
              }
              return GestureDetector(
                onTap: () => _showActions(),
                child: const RotationTransition(
                  turns: AlwaysStoppedAnimation(30 / 360),
                  child: Icon(
                    Icons.attach_file_outlined,
                    size: 20,
                    color: AppColors.blueDodger,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          BlocBuilder<FormQueriesCubit, FormQueriesState>(
            builder: (context, state) {
              if (state is FormQueriesAttachmentSuccess) {
                return SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.attachments.length,
                    itemBuilder: (context, i) {
                      var attachment = state.attachments[i];
                      var fileName = attachment.path.split('/').last;
                      fileName = fileName.length > 20
                          ? fileName.substring(0, 20)
                          : fileName;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              var document = PatientDocument();
                              document.file = attachment;
                              document.fileName = fileName;
                              Navigator.of(context).push(_preview(document));
                            },
                            child: Text(fileName.length > 20
                                ? fileName.substring(0, 20)
                                : fileName),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              formQueriesCubit.deleteDocument(i);
                            },
                            child: const Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
              return emptyBox;
            },
          ),
          const Spacer(),
          BlocBuilder<FormQueriesCubit, FormQueriesState>(
            builder: (context, state) {
              if (state is FormQueriesCommentSending) {
                return const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(),
                );
              }
              return GestureDetector(
                onTap: () {
                  formQueriesCubit.replyComment(_commentController.text);
                },
                child: const Icon(
                  Icons.send,
                  color: AppColors.blueDodger,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _CommentsSection extends StatelessWidget {
  _CommentsSection({Key? key}) : super(key: key);
  final List<FormQueryComments> comments = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormQueriesCubit, FormQueriesState>(
      builder: (context, state) {
        if (state is FormQueriesError) {
          return Text(
            state.message,
            style: AppTextStyles.w400s16red,
          );
        }
        if (state is FormQueriesCommentsLoading) {
          return const SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(),
          );
        }
        if (state is FormQueriesCommentsLoaded) {
          comments
            ..clear()
            ..addAll(state.comments);
        }
        return _commentWidget();
      },
    );
  }

  Widget _commentWidget() {
    if (comments.isEmpty) return emptyBox;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Comments', style: AppTextStyles.w600s16black),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              FormQueryComments comment = comments[index];
              final commentTime = comment.lastUpdated.split('T');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        comment.createdByUser,
                        style: AppTextStyles.w600s16black,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${commentTime.first} ${commentTime.last.split('.').first}',
                        style: AppTextStyles.w400s16grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    comment.content,
                    style: AppTextStyles.w400s16black,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comment.attachments.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        context
                            .read<FormQueriesCubit>()
                            .downloadDocument(comment.attachments[index]);
                      },
                      child: BlocBuilder<FormQueriesCubit, FormQueriesState>(
                        builder: (context, state) {
                          if (state is FormQueriesDocumentDownloading) {
                            if (state.fileName == comment.attachments[index]) {
                              return const Center(
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const RotationTransition(
                                turns: AlwaysStoppedAnimation(30 / 360),
                                child: Icon(
                                  Icons.attach_file_outlined,
                                  size: 20,
                                  color: AppColors.blueDodger,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  comment.attachments[index] ?? '',
                                  style: AppTextStyles.w400s14dodgerBlue,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

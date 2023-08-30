import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/presentations/widgets/custom_webview.dart';
import '../../constants/app_colors.dart';

class PreviewPatientDocumentScreen extends StatelessWidget {
  const PreviewPatientDocumentScreen({Key? key, required this.document})
      : super(key: key);
  final PatientDocument document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          document.fileName.split('/').last,
          style: AppTextStyles.w500s16black,
        ),
        centerTitle: false,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: document.file != null
            ? Image.file(
                document.file!,
                fit: BoxFit.fill,
                errorBuilder: (ctx, err, trace) => Container(
                  color: Colors.grey,
                  width: 100,
                  height: 100,
                  child: const Center(
                    child:
                        Text('Error load image', textAlign: TextAlign.center),
                  ),
                ),
              )
            : CustomWebView(url: document.fileUrl),
      ),
    );
  }
}

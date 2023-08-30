import 'package:flutter/material.dart';
import 'package:talosix/app/constants/app_constants.dart';
import 'package:talosix/app/presentations/widgets/custom_webview.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Your User Guide',
          style: AppTextStyles.w500s18holly,
        ),
      ),
      body: const SafeArea(
        child: CustomWebView(url: AppConstants.userGuideLink),
      ),
    );
  }
}

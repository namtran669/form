import 'package:flutter/material.dart';
import 'package:talosix/app/constants/app_images.dart';

import '../presentations/widgets/common_view.dart';
import '../styles/app_styles.dart';

enum ToastMessageType { message, error, warning, uploading }

extension BuildContextExt on BuildContext {
  showMessage(ToastMessageType type, String message) {
    MaterialColor color;
    Widget icon;
    switch (type) {
      case ToastMessageType.message:
        color = Colors.green;
        icon = const Icon(Icons.check, color: Colors.white);
        break;
      case ToastMessageType.error:
        color = Colors.red;
        icon = const Icon(Icons.warning, color: Colors.white);
        break;
      case ToastMessageType.warning:
        color = Colors.orange;
        icon = const Icon(Icons.warning, color: Colors.white);
        break;
      case ToastMessageType.uploading:
        color = Colors.blue;
        icon = Image.asset(
          AppIcons.uploading,
          color: Colors.white,
          width: 20,
          height: 20,
        );
        break;
    }

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.w400s15white,
              ),
            ),
            message.length < 25 ? const Spacer() : emptyBox,
            IconButton(
              color: Colors.white,
              onPressed: () => ScaffoldMessenger.of(this).hideCurrentSnackBar(),
              icon: const Icon(
                Icons.close,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isKeyboardShowing() {
    return WidgetsBinding.instance.window.viewInsets.bottom > 0;
  }

  closeKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

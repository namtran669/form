import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppButtonStyle {
  static ButtonStyle kButtonPictonBlueBorder5 = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      AppColors.pictonBlue,
    ),
  );
}
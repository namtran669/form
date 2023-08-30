import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants/app_colors.dart';
import '../../styles/app_styles.dart';

const Widget emptyBox = SizedBox.shrink();

Widget passwordGuide = Text('''• Password must be 8 - 25 characters.
                              \n• Password must contain at least:
                              \n \t • One digit (0 - 9)
                              \n \t • One uppercase letter (A - Z)
                              \n \t • One lowercase letter (a - z)
                              \n \t • One special character (!@#% ^*()_+-).''',
    style: AppTextStyles.w400s14black.copyWith(height: 1));

Center loadingIndicator(context) {
  return Center(
    child: SpinKitDoubleBounce(
      size: 40,
      color: Theme.of(context).colorScheme.secondary,
    ),
  );
}

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.dodgerBlue,
        ),
      ),
    );
  }
}

const Widget defaultAvatar = Icon(
  Icons.account_circle,
  size: 50,
  color: AppColors.dustyGray,
);

Widget statusOnline = Container(
  width: 12,
  height: 12,
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    color: AppColors.forestGreen,
  ),
);

Widget statusNewMessage = Container(
  width: 12,
  height: 12,
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.blue,
  ),
);

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';

class MfaVerifySuccessScreen extends StatelessWidget {
  const MfaVerifySuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AppImages.appLogoBranding,
                height: 150.0,
                width: 200.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Strings.tr.twoFactorAuthenticationVerified,
                    style: AppTextStyles.w600s20black,
                  ),
                  const SizedBox(height: 45),
                  Image.asset(
                    AppImages.tickButton,
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Your account has been verified successfully.',
                    style: AppTextStyles.w500s16black,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.main);
                      },
                      style: AppButtonStyles.r40blueDodger,
                      child: const Center(
                        child: Text(
                          'Next',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

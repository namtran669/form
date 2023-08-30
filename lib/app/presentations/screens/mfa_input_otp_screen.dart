import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:talosix/app/blocs/mfa_auth/mfa_cubit.dart';
import 'package:talosix/app/extensions/context_ext.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';
import 'auth_input_otp_screen.dart';

class MfaInputOtpScreen extends StatelessWidget {
  final bool isPhoneOtp;

  const MfaInputOtpScreen({Key? key, this.isPhoneOtp = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MfaCubit mfaCubit = context.read<MfaCubit>();

    const focusedBorderColor = AppColors.blueDodger;
    const borderColor = Colors.black54;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: AppTextStyles.w500s20black,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor),
      ),
    );

    return BlocConsumer<MfaCubit, MfaState>(listener: (context, state) {
      if (state is MfaSettingSuccess) {
        Navigator.of(context).pushNamed(Routes.mfaVerifySuccess);
      } else if (state is MfaVerifyOtpFail) {
        context.showMessage(ToastMessageType.error, state.msg);
      }
    }, builder: (context, state) {
      bool isLoading = false;
      if (state is MfaInProgress) {
        isLoading = true;
      }
      return LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: loadingIndicator(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.malibu,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 85,
                          maxHeight: 120,
                          minWidth: double.infinity,
                          maxWidth: double.infinity,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: isPhoneOtp ? 43 : 79,
                            height: isPhoneOtp ? 76 : 63,
                            child: Image.asset(isPhoneOtp
                                ? AppImages.phone
                                : AppImages.letter),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          isPhoneOtp
                              ? Strings.tr.verifyYourMobilePhone
                              : Strings.tr.verifyYourEmailAddress,
                          style: AppTextStyles.w600s20black,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          isPhoneOtp
                              ? 'Kindly input the code was sent to your mobile phone for confirmation'
                              : 'Kindly input the code was sent to your email address for confirmation',
                          style: AppTextStyles.w500s15black,
                        ),
                        const SizedBox(height: 25),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            length: 6,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsUserConsentApi,
                            listenForMultipleSmsOnAndroid: true,
                            defaultPinTheme: defaultPinTheme,
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (value) {
                              mfaCubit.setOtp = value;
                            },
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  color: focusedBorderColor,
                                ),
                              ],
                            ),
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: focusedBorderColor),
                              ),
                            ),
                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: focusedBorderColor),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyBorderWith(
                              border: Border.all(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Did not receive any code?',
                          style: AppTextStyles.kNormal4GoldSize13,
                        ),
                        const SizedBox(height: 16),
                        RequestOtpButton(
                            onPress: () => context
                                .read<MfaCubit>()
                                .requestOtpVerificationChallenge()),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              mfaCubit.verifyOtpAndSettingPhone();
                            },
                            style: AppButtonStyles.r40blueDodger,
                            child: const Text(
                              'Verify',
                              style: AppTextStyles.w500s15white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

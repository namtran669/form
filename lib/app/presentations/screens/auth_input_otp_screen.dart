import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:pinput/pinput.dart';
import 'package:talosix/app/blocs/auth/auth_cubit.dart';
import 'package:talosix/app/blocs/auth/auth_state.dart';
import 'package:talosix/app/extensions/context_ext.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';

class AuthInputOtpScreen extends StatelessWidget {
  const AuthInputOtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<AuthCubit>();

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

    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) async {
      if (state is AuthLoginSuccess) {
        Navigator.of(context).pushReplacementNamed(Routes.main);
      } else if (state is AuthConfirmSignInFail) {
        context.showMessage(ToastMessageType.error, state.message);
      } else if (state is AuthRequestNewOtpSuccess) {
        context.showMessage(ToastMessageType.message, state.message);
      }
    }, builder: (context, state) {
      bool isLoading = state is AuthConfirmingSignIn;
      return LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: loadingIndicator(context),
        child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.appLogoBranding,
                    height: 150,
                    width: 200,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            Strings.tr.authenticateYourAccount,
                            style: AppTextStyles.w600s20black,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          Strings.tr.enterTheSixDigit,
                          style: AppTextStyles.w400s14black,
                        ),
                        const SizedBox(height: 50),
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
                              authCubit.otp = value;
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
                                border: Border.all(
                                  color: focusedBorderColor,
                                ),
                              ),
                            ),
                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(
                                  color: focusedBorderColor,
                                ),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyBorderWith(
                              border: Border.all(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          'Did not receive any code?',
                          style: AppTextStyles.kNormal4GoldSize13,
                        ),
                        const SizedBox(height: 8),
                        RequestOtpButton(onPress: () {
                          context.read<AuthCubit>().requestNewOtp();
                        }),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuthCubit>().confirmSignIn();
                            },
                            style: AppButtonStyles.r40blueDodger,
                            child: const Center(
                              child: Text(
                                'Verify',
                                // style: AppTextStyles.,
                              ),
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

class RequestOtpButton extends StatefulWidget {
  RequestOtpButton({Key? key, required this.onPress}) : super(key: key);
  final String otpTitle = 'Resend OTP code';
  final Color enableColor = Colors.teal;
  final Color disableColor = Colors.grey.shade400;
  final int time = 60;
  final VoidCallback onPress;

  @override
  State<RequestOtpButton> createState() => _RequestOtpButtonState();
}

class _RequestOtpButtonState extends State<RequestOtpButton> {
  Timer? _timer;
  int _start = 60;
  bool _isCounting = false;
  late String _btnTitle;
  late Color _btnColor;

  setNormalState() {
    _start = widget.time;
    _btnTitle = widget.otpTitle;
    _isCounting = false;
    _btnColor = Colors.teal;
  }

  setCountingState() {
    _start--;
    _btnTitle = '${widget.otpTitle} in: $_start s';
    _isCounting = true;
    _btnColor = Colors.grey.shade400;
  }

  @override
  void initState() {
    setNormalState();
    setCountingState();
    startTimer();
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            setNormalState();
          });
        } else {
          setState(() {
            setCountingState();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_isCounting) return;
          widget.onPress.call();
          startTimer();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(_btnColor),
        ),
        child: Center(
          child: Text(
            _btnTitle,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';
import 'package:talosix/app/presentations/widgets/text_form_builder.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/form_validator/app_form_cubit.dart';
import '../../styles/app_styles.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/custom_required_question.dart';
import '../widgets/password_form_field.dart';

class ConfirmForgotPasswordScreen extends StatelessWidget {
  ConfirmForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _confirmTC = TextEditingController();
  final TextEditingController _passwordTC = TextEditingController();
  final TextEditingController _codeTC = TextEditingController();

  final FocusNode _passwordFN = FocusNode();
  final FocusNode _confirmFN = FocusNode();
  final FocusNode _codeFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    var formCubit = context.read<AppFormCubit>();
    var authCubit = context.read<AuthCubit>();
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is AuthConfirmForgotPasswordSuccess) {
        context.showMessage(
          ToastMessageType.message,
          Strings.tr.forgotPasswordSuccess,
        );
        Navigator.of(context)
            .popUntil((route) => route.settings.name == Routes.login);
      } else if (state is AuthConfirmForgotPasswordError) {
        context.showMessage(
          ToastMessageType.error,
          state.message,
        );
      }
    }, builder: (context, state) {
      bool isLoading = false;
      if (state is AuthInProgress) {
        isLoading = true;
      }
      return LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: loadingIndicator(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 1070,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Center(
                        child: Image.asset(
                          AppImages.appLogoBranding,
                          height: 150,
                          width: 250,
                        ),
                      ),
                      Text(
                        Strings.tr.resetPassword,
                        style: AppTextStyles.w500s20black,
                      ),
                      Text(
                        Strings.tr.inputVerificationCodeGuide,
                        style: AppTextStyles.w400s15orangeAccent,
                      ),
                      const SizedBox(height: 8),
                      const RequiredText('Verification Code'),
                      const SizedBox(height: 8),
                      BlocBuilder<AppFormCubit, AppFormState>(
                          builder: (context, state) {
                        String? message;
                        if (state is AppFormValidateForgotChangePassword) {
                          if (!state.isCodeValid) {
                            message = 'Code is required.';
                          }
                        }
                        if (state is AppFormCodeRequired) {
                          message = 'Code is required.';
                        }
                        return TextFormBuilder(
                          controller: _codeTC,
                          hintText: Strings.tr.verificationCode,
                          labelText: Strings.tr.code,
                          textInputAction: TextInputAction.next,
                          focusNode: _codeFN,
                          nextFocusNode: _passwordFN,
                          errorText: message,
                          onChange: (value) => formCubit.validateCode(value),
                        );
                      }),
                      Row(
                        children: [
                          const Spacer(),
                          RequestVerificationCodeButton(onPress: () {
                            authCubit
                                .resendVerificationCodeForgotPassword(email);
                          }),
                        ],
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          Strings.tr.confirmForgotPasswordGuide,
                          style: AppTextStyles.w500s20black,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          email,
                          style: AppTextStyles.w500s16black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const RequiredText('New Password'),
                            const SizedBox(height: 8),
                            BlocBuilder<AppFormCubit, AppFormState>(
                              builder: (context, state) {
                                String? passMsg;
                                if (state is AppFormPasswordFormat) {
                                  if (!state.isValid) {
                                    passMsg =
                                        'Password does not meet requirements.';
                                  }
                                } else if (state
                                    is AppFormValidateForgotChangePassword) {
                                  if (!state.isPasswordValid) {
                                    passMsg =
                                        'Password does not meet requirements.';
                                  }
                                }
                                return Focus(
                                  onFocusChange: (hasFocused) {
                                    if (!hasFocused) {
                                      formCubit.validateNewPassword(
                                        _passwordTC.text,
                                      );
                                    }
                                  },
                                  child: PasswordFormBuilder(
                                    controller: _passwordTC,
                                    prefix: CupertinoIcons.lock,
                                    suffix: CupertinoIcons.eye,
                                    hintText: Strings.tr.newPassword,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _passwordFN,
                                    nextFocusNode: _confirmFN,
                                    errorText: passMsg,
                                    labelText: Strings.tr.newPassword,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            const RequiredText('Confirm Password'),
                            const SizedBox(height: 8),
                            BlocBuilder<AppFormCubit, AppFormState>(
                              builder: (context, state) {
                                String? message;
                                if (state is AppFormPasswordNotMatch) {
                                  message =
                                      'The confirm password is not match.';
                                } else if (state
                                    is AppFormValidateForgotChangePassword) {
                                  if (!state.isConfirmValid) {
                                    message =
                                        'The confirm password is not match.';
                                  }
                                }
                                return Focus(
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus) {
                                      formCubit.isMatchPassword(
                                        _passwordTC.text,
                                        _confirmTC.text,
                                      );
                                    }
                                  },
                                  child: PasswordFormBuilder(
                                    controller: _confirmTC,
                                    prefix: CupertinoIcons.lock,
                                    suffix: CupertinoIcons.eye,
                                    hintText: Strings.tr.confirmPassword,
                                    labelText: Strings.tr.confirmPassword,
                                    textInputAction: TextInputAction.done,
                                    submitAction: () => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    focusNode: _confirmFN,
                                    errorText: message,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            String code = _codeTC.text;
                            String password = _passwordTC.text;
                            String confirm = _confirmTC.text;
                            bool isFormValid =
                                formCubit.validateConfirmForgotPasswordForm(
                              code,
                              password,
                              confirm,
                            );
                            if (isFormValid) {
                              authCubit.confirmForgotPassword(
                                  email, password, code);
                            }
                          },
                          style: AppButtonStyles.r40blueDodger,
                          child: const Center(
                            child: Text(
                              'Reset My Password',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      passwordGuide,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class RequestVerificationCodeButton extends StatefulWidget {
  RequestVerificationCodeButton({Key? key, required this.onPress})
      : super(key: key);

  final int time = 120;
  final String title = 'Resend me the code';
  final TextStyle enableStyle = AppTextStyles.w400s15orangeAccent;
  final TextStyle disableStyle = AppTextStyles.w400s15grey400;
  final VoidCallback onPress;

  @override
  State<RequestVerificationCodeButton> createState() =>
      _RequestVerificationCodeButtonState();
}

class _RequestVerificationCodeButtonState
    extends State<RequestVerificationCodeButton> {
  late String _btnTitle;

  late Timer? _timer;
  late int _start;
  late bool _isCounting;
  late TextStyle _style;

  setNormalState() {
    _btnTitle = widget.title;
    _start = widget.time;
    _isCounting = false;
    _style = widget.enableStyle;
  }

  setCountingState() {
    _btnTitle = '${widget.title} in: $_start s';
    _start--;
    _isCounting = true;
    _style = widget.disableStyle;
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
      child: TextButton(
        onPressed: () {
          if (_isCounting) return;
          widget.onPress.call();
          startTimer();
        },
        child: Text(
          _btnTitle,
          style: _style,
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

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/widgets/text_form_builder.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/form_validator/app_form_cubit.dart';
import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _emailTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<AppFormCubit>().clearValidate();
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is AuthRequestForgotPasswordSuccess) {
        context.showMessage(
          ToastMessageType.message,
          Strings.tr.verificationCodeSuccessMessage,
        );
        Navigator.of(context).pushNamed(
          Routes.confirmForgotPassword,
          arguments: _emailTC.text,
        );
      } else if (state is AuthRequestForgotPasswordError) {
        context.showMessage(ToastMessageType.error, state.message);
      }
    }, builder: (context, state) {
      bool isLoading = state is AuthInProgress;
      return LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: loadingIndicator(context),
        child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${Strings.tr.forgotYourPassword}?',
                            style: AppTextStyles.w600s20black,
                          ),
                          const SizedBox(height: 50),
                          Text(
                            Strings.tr.forgotYourPasswordGuide,
                            style: AppTextStyles.w400s15black,
                          ),
                          const SizedBox(height: 50),
                          Form(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: BlocBuilder<AppFormCubit, AppFormState>(
                              builder: (context, state) {
                                String? message;
                                if (state is AppFormEmailFormat) {
                                  if (!state.isValid) {
                                    message =
                                        'Please enter a valid email address.';
                                  }
                                }
                                if (state is AppFormEmailRequired) {
                                  message = 'Email is required.';
                                }
                                return TextFormBuilder(
                                  controller: _emailTC,
                                  hintText: Strings.tr.enterYourEmailAddress,
                                  labelText: Strings.tr.email,
                                  textInputAction: TextInputAction.done,
                                  submitAction: () => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
                                  errorText: message,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            height: 50.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => nextStep(context, _emailTC.text),
                              style: AppButtonStyles.r40blueDodger,
                              child: const Center(
                                child: Text(
                                  'Next Step',
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
        ),
      );
    });
  }

  nextStep(BuildContext context, String email) {
    bool isValidEmail = context.read<AppFormCubit>().validateEmail(email);
    if (isValidEmail) {
      context.read<AuthCubit>().forgotPassword(email);
    }
  }
}

import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/constants/app_images.dart';
import 'package:talosix/app/extensions/context_ext.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/chat/chat_cubit.dart';
import '../../blocs/form_validator/app_form_cubit.dart';
import '../../blocs/user/user_profile_cubit.dart';
import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';
import '../widgets/password_form_field.dart';
import '../widgets/text_form_builder.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailTC = TextEditingController();
  final TextEditingController _passwordTC = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final FocusNode _passFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final formCubit = context.read<AppFormCubit>();
    final appUserProfileCubit = context.read<AppUserProfileCubit>();
    final chatCubit = context.read<ChatCubit>();
    _emailTC.text = AppUserDataModel().email ?? '';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          appUserProfileCubit.fetchUserProfile();
          chatCubit.loginFirebase();
          Navigator.of(context).pushReplacementNamed(state.nextRoute);
        } else if (state is AuthLoginFailed) {
          context.showMessage(ToastMessageType.error, state.message);
        }
      },
      builder: (context, state) {
        bool isLoading = false;
        if (state is AuthInProgress) {
          isLoading = true;
        }
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: LoadingOverlay(
            isLoading: isLoading,
            progressIndicator: loadingIndicator(context),
            child: Scaffold(
              backgroundColor: AppColors.background,
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.appLogoBranding,
                        height: 150,
                        width: 250,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Text(
                                Strings.tr.signIntoTalosix,
                                style: AppTextStyles.w500s20black,
                              ),
                            ),
                            const SizedBox(height: 35),
                            Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email Address',
                                    style: AppTextStyles.w400s16black,
                                  ),
                                  const SizedBox(height: 8),
                                  BlocBuilder<AppFormCubit, AppFormState>(
                                    builder: (context, state) {
                                      String? message;
                                      if (state is AppFormEmailFormat) {
                                        if (!state.isValid) {
                                          message =
                                              'Please enter a valid email address.';
                                        }
                                      }
                                      return Focus(
                                        onFocusChange: (hasFocus) {
                                          if (hasFocus) {
                                            formCubit.clearValidate();
                                          } else {
                                            formCubit
                                                .validateEmail(_emailTC.text);
                                          }
                                        },
                                        child: TextFormBuilder(
                                          controller: _emailTC,
                                          prefix: CupertinoIcons.mail,
                                          hintText:
                                              Strings.tr.enterYourEmailAddress,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _emailFN,
                                          nextFocusNode: _passFN,
                                          errorText: message,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 25),
                                  const Text(
                                    'Password',
                                    style: AppTextStyles.w400s16black,
                                  ),
                                  const SizedBox(height: 8),
                                  PasswordFormBuilder(
                                    controller: _passwordTC,
                                    prefix: CupertinoIcons.lock,
                                    hintText: Strings.tr.enterYourPassword,
                                    textInputAction: TextInputAction.done,
                                    submitAction: () => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    focusNode: _passFN,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Center(
                              child: SizedBox(
                                height: 50.0,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    bool isEmailValid =
                                        formCubit.validateEmail(_emailTC.text);
                                    if (isEmailValid) {
                                      authCubit.login(
                                        _emailTC.text,
                                        _passwordTC.text,
                                      );
                                    }
                                  },
                                  style: AppButtonStyles.r40blueDodger,
                                  child: const Center(
                                    child: Text(
                                      'Sign In',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(Routes.forgotPassword),
                              child: const Text(
                                'Forgot Password?',
                                style: AppTextStyles.w500s14grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(Routes.requestRegisterAccount),
                              child: const Text(
                                'Request New Account?',
                                style: AppTextStyles.w500s14grey,
                              ),
                            ),
                            const Spacer(),
                            const Center(
                              child: Text(
                                'Version ${AppConstants.appVersion}',
                                style: AppTextStyles.w400s14grey,
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
      },
    );
  }
}

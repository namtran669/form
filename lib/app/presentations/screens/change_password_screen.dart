import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';

import '../../blocs/form_validator/app_form_cubit.dart';
import '../../blocs/user/user_profile_cubit.dart';
import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../widgets/custom_required_question.dart';
import '../widgets/password_form_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _currentPasswordTC = TextEditingController();
  final TextEditingController _passwordTC = TextEditingController();
  final TextEditingController _confirmTC = TextEditingController();

  final FocusNode _currentFN = FocusNode();
  final FocusNode _passwordFN = FocusNode();
  final FocusNode _confirmFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    var formCubit = context.read<AppFormCubit>();
    return BlocConsumer<AppUserProfileCubit, AppUserProfileState>(
        listener: (context, state) {
      if (state is UserChangePasswordSuccess) {
        context.showMessage(
          ToastMessageType.message,
          'Your password has been successfully updated.',
        );
        Navigator.of(context).pop();
      } else if (state is UserChangePasswordError) {
        context.showMessage(
          ToastMessageType.error,
          state.message,
        );
      }
    }, builder: (context, state) {
      bool isLoading = state is UserFetchProfileInProgress;
      return LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: loadingIndicator(context),
        child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            iconTheme: const IconThemeData(color: Colors.black87),
            title: const Text('Change Your Password',
                style: AppTextStyles.w500s18holly),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RequiredText('Current Password'),
                        const SizedBox(height: 8),
                        BlocBuilder<AppFormCubit, AppFormState>(
                          builder: (context, state) {
                            String? message;
                            if (state is AppFormPasswordRequired) {
                              message = 'Current password is required.';
                            }
                            return PasswordFormBuilder(
                              controller: _currentPasswordTC,
                              prefix: CupertinoIcons.lock,
                              suffix: CupertinoIcons.eye,
                              hintText: Strings.tr.currentPassword,
                              textInputAction: TextInputAction.next,
                              submitAction: () {},
                              focusNode: _currentFN,
                              nextFocusNode: _passwordFN,
                              errorText: message,
                              onChange: (value) => context
                                  .read<AppFormCubit>()
                                  .validateCurrentPassword(value),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
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
                                            _passwordTC.text);
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
                          height: 50.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              String current = _currentPasswordTC.text;
                              String password = _passwordTC.text;
                              String confirm = _confirmTC.text;
                              bool isFormValid =
                                  formCubit.validateChangePasswordForm(
                                current,
                                password,
                                confirm,
                              );

                              if (isFormValid) {
                                context
                                    .read<AppUserProfileCubit>()
                                    .changePassword(current, password);
                              }
                            },
                            style: AppButtonStyles.r40blueDodger,
                            child: const Center(
                              child: Text(
                                'Change Password',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        passwordGuide,
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

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/form_validator/app_form_cubit.dart';
import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/password_form_field.dart';

class ConfirmAccountScreen extends StatelessWidget {
  ConfirmAccountScreen({Key? key}) : super(key: key);

  final TextEditingController _confirmPasswordTC = TextEditingController();
  final TextEditingController _passwordTC = TextEditingController();
  final FocusNode _passwordFN = FocusNode();
  final FocusNode _confirmFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    var formCubit = context.read<AppFormCubit>();
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is AuthConfirmAccountSuccess) {
        Navigator.of(context).pushNamed(Routes.termAndCondition);
      } else if (state is AuthUpdatePasswordFail) {
        context.showMessage(ToastMessageType.error, state.reason);
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
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      AppImages.appLogoBranding,
                      height: 100.0,
                      width: 150.0,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            Strings.tr.createAnewPassword,
                            style: AppTextStyles.kNormal6BlackSize20,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              BlocBuilder<AppFormCubit, AppFormState>(
                                builder: (context, state) {
                                  String? message;
                                  if (state is AppFormPasswordFormat) {
                                    if (!state.isValid) {
                                      message =
                                          'Password does not meet requirements.';
                                    }
                                  }
                                  return PasswordFormBuilder(
                                      controller: _passwordTC,
                                      prefix: CupertinoIcons.lock,
                                      suffix: CupertinoIcons.eye,
                                      hintText: Strings.tr.password,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _passwordFN,
                                      nextFocusNode: _confirmFN,
                                      errorText: message,
                                      labelText: Strings.tr.password,
                                      onChange: (value) {
                                        if (value.length > 7) {
                                          formCubit
                                              .validateLoginPassword(value);
                                        }
                                      });
                                },
                              ),
                              const SizedBox(height: 20.0),
                              PasswordFormBuilder(
                                controller: _confirmPasswordTC,
                                prefix: CupertinoIcons.lock,
                                suffix: CupertinoIcons.eye,
                                hintText: Strings.tr.confirmPassword,
                                labelText: Strings.tr.confirmPassword,
                                textInputAction: TextInputAction.done,
                                submitAction: () => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                focusNode: _confirmFN,
                              ),
                              const SizedBox(height: 16),
                              passwordGuide,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 50.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => changePassword(context),
                              style: AppButtonStyles.r40blueDodger,
                              child: const Center(
                                child: Text(
                                  'Update',
                                ),
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

  changePassword(BuildContext context) {
    String password = _passwordTC.text;
    String confirm = _confirmPasswordTC.text;
    if (context.read<AppFormCubit>().isMatchPassword(password, confirm)) {
      context.read<AuthCubit>().confirmAccount(password);
    } else {
      context.showMessage(
          ToastMessageType.error, 'The confirm password is not match');
    }
  }
}

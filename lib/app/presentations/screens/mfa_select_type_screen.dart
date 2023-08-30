import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/blocs/mfa_auth/mfa_cubit.dart';
import 'package:talosix/app/extensions/context_ext.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';

class MfaSelectTypeScreen extends StatelessWidget {
  MfaSelectTypeScreen({Key? key}) : super(key: key);
  final listMfa = ListMFA();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MfaCubit, MfaState>(
      listener: (context, state) {
        if (state is MfaSettingSuccess) {
          Navigator.of(context).pushNamed(Routes.mfaVerifySuccess);
        } else if (state is MfaSettingFail) {
          context.showMessage(ToastMessageType.error, state.msg);
        }
      },
      builder: (context, state) {
        bool isLoading = false;
        if (state is MfaInProgress) {
          isLoading = true;
        }
        return LoadingOverlay(
          isLoading: isLoading,
          progressIndicator: loadingIndicator(context),
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImages.appLogoBranding,
                      height: 150.0,
                      width: 200.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.tr.selectAuthenticationMethod,
                          style: AppTextStyles.w600s20black,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          Strings.tr.goingForward,
                          style: AppTextStyles.w500s15black,
                        ),
                        const SizedBox(height: 30),
                        listMfa,
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 50.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (listMfa.typeSelected == MfaType.undefine) {
                                context.showMessage(
                                  ToastMessageType.error,
                                  'Please select at least one MFA method before continue.',
                                );
                                return;
                              }

                              if (listMfa.typeSelected == MfaType.phone) {
                                if (listMfa.isAgreeSms) {
                                  Navigator.of(context)
                                      .pushNamed(Routes.mfaInputPhoneNumber);
                                } else {
                                  context.showMessage(
                                    ToastMessageType.error,
                                    'Please check this box if you want to proceed '
                                    'with SMS messages. Alternatively, select email.',
                                  );
                                }
                                return;
                              }

                              if (listMfa.typeSelected == MfaType.email) {
                                context
                                    .read<MfaCubit>()
                                    .settingMfa(isPhone: false);
                                return;
                              }
                            },
                            style: AppButtonStyles.r40blueDodger,
                            child: const Center(
                              child: Text(
                                'Next',
                                style: AppTextStyles.w500s15white,
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
          ),
        );
      },
    );
  }
}

class ListMFA extends StatefulWidget {
  MfaType typeSelected = MfaType.undefine;
  bool isAgreeSms = false;

  ListMFA({Key? key}) : super(key: key);

  @override
  State<ListMFA> createState() => _ListMFAState();
}

class _ListMFAState extends State<ListMFA> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: Colors.black),
          ),
          child: RadioListTile<MfaType>(
            title: const Text(
              'Verify via Email',
              style: AppTextStyles.w500s14black,
            ),
            value: MfaType.email,
            groupValue: widget.typeSelected,
            onChanged: (_) {
              setState(() {
                widget.typeSelected = MfaType.email;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(5.0) //                 <--- border radius here
                ),
            border: Border.all(color: Colors.black),
          ),
          child: RadioListTile<MfaType>(
            title: const Text(
              'Verify via Mobile Phone Number',
              style: AppTextStyles.w500s14black,
            ),
            value: MfaType.phone,
            groupValue: widget.typeSelected,
            onChanged: (position) {
              setState(() {
                widget.typeSelected = MfaType.phone;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        widget.typeSelected == MfaType.phone
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      value: widget.isAgreeSms,
                      onChanged: (value) {
                        setState(() {
                          widget.isAgreeSms = value!;
                        });
                      }),
                  const SizedBox(width: 3),
                  const Flexible(
                    child:
                        Text('I agree to receive automated transactional SMS '
                            'notifications from Talosix.'),
                  )
                ],
              )
            : emptyBox,
      ],
    );
  }
}

enum MfaType {
  phone,
  email,
  undefine;
}

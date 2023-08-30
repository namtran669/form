import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/blocs/mfa_auth/mfa_cubit.dart';
import 'package:talosix/app/extensions/context_ext.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';

class MfaInputPhoneNumberScreen extends StatelessWidget {
  MfaInputPhoneNumberScreen({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();
  var selectedCountry = PhoneNumber(isoCode: 'US');

  @override
  Widget build(BuildContext context) {
    MfaCubit mfaCubit = context.read<MfaCubit>();
    return BlocConsumer<MfaCubit, MfaState>(
      listener: (context, state) {
        if (state is MfaRequestOtpSuccess) {
          Navigator.of(context).pushNamed(Routes.mfaInputPhoneOtp);
        } else if (state is MfaRequestOtpFail) {
          context.showMessage(ToastMessageType.error, state.msg);
        }
      },
      builder: (context, state) {
        bool isLoading = state is MfaRequestOtpInProgress;
        return LoadingOverlay(
          isLoading: isLoading,
          progressIndicator: loadingIndicator(context),
          child: Scaffold(
            backgroundColor: AppColors.background,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImages.appLogoBranding,
                      height: 150,
                      width: 200,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            Strings.tr.enterYourPhoneNumber,
                            style: AppTextStyles.w600s20black,
                          ),
                        ),
                        const SizedBox(height: 38.0),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: InternationalPhoneNumberInput(
                            initialValue: selectedCountry,
                            onInputChanged: (PhoneNumber number) {
                              selectedCountry = number;
                              mfaCubit.setPhone = number.phoneNumber;
                            },
                            selectorConfig: const SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET),
                            spaceBetweenSelectorAndTextField: 2,
                            // maxLength: 10,
                            ignoreBlank: false,
                            selectorTextStyle:
                                const TextStyle(color: Colors.black),
                            textFieldController: _controller,
                            formatInput: false,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            inputBorder: InputBorder.none,
                            countrySelectorScrollControlled: false,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              mfaCubit.requestOtpVerificationChallenge();
                            },
                            style: AppButtonStyles.r40blueDodger,
                            child: const Center(
                              child: Text(
                                'Next',
                                // style: AppTextStyles.,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/blocs/user/user_profile_cubit.dart';
import 'package:talosix/app/extensions/context_ext.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';

class RequestRegisterScreen extends StatefulWidget {
  const RequestRegisterScreen({Key? key}) : super(key: key);

  @override
  State<RequestRegisterScreen> createState() => _RequestRegisterScreenState();
}

class _RequestRegisterScreenState extends State<RequestRegisterScreen> {
  final TextEditingController _feedbackTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserProfileCubit, AppUserProfileState>(
        listener: (context, state) {
      if (state is AppUserSendFeedbackSuccess) {
        context.showMessage(
          ToastMessageType.message,
          'Thanks! We will contact you and send the account information via your email soon.',
        );
        Navigator.of(context).pop();
      } else if (state is AppUserSendFeedbackError) {
        context.showMessage(
          ToastMessageType.error,
          state.message,
        );
      }
    }, builder: (context, state) {
      return LoadingOverlay(
        isLoading: state is AppUserSendFeedbackInProgress,
        child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            iconTheme: const IconThemeData(color: Colors.black87),
            title: const Text('Request Register Account', style: AppTextStyles.w500s18holly),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Please input your contact information, we will contact you for auditing and creating an account.',
                    style: AppTextStyles.w500s16dodgerBlue,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _feedbackTC,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      hintText: 'Your contact information ...',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_feedbackTC.text != '') {
                          context.read<AppUserProfileCubit>().sendFeedback(_feedbackTC.text);
                        }
                      },
                      style: AppButtonStyles.r40blueDodger,
                      child: const Center(
                        child: Text(
                          'Send',
                        ),
                      ),
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

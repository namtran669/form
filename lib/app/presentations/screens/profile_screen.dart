import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/blocs/auth/auth_cubit.dart';
import 'package:talosix/app/blocs/auth/auth_state.dart';
import 'package:talosix/app/blocs/chat/chat_cubit.dart';
import 'package:talosix/app/blocs/treatment/treatment_bloc.dart';
import 'package:talosix/app/constants/app_constants.dart';
import 'package:talosix/app/constants/app_images.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/screens/update_your_avatar_screen.dart';
import 'package:talosix/app/presentations/widgets/custom_app_dialog.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../blocs/app_bottom_bar/app_bottom_bar_bloc.dart';
import '../../blocs/form_incomplete/form_incomplete_bloc.dart';
import '../../blocs/form_question/form_detail_cubit.dart';
import '../../blocs/patient_document/patient_document_cubit.dart';
import '../../blocs/study_patient/study_cubit.dart';
import '../../constants/app_colors.dart';
import '../../routes/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLogoutSuccess) {
                _clearBlocData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.login,
                  (route) => false,
                );
              } else if (state is AuthLogoutFail) {
                context.showMessage(
                  ToastMessageType.error,
                  state.message,
                );
              }
            },
            child: SingleChildScrollView(
              child: SizedBox(
                height: 650,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.tr.profile,
                      style: AppTextStyles.w500s20dodgerBlue,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Update your settings like notifications and security preferences.',
                      style: AppTextStyles.w400s16grey,
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 200,
                      child: _ProfileSection(
                        title: 'Account Settings',
                        menu: [
                          _SettingItem(
                            AppIcons.settingKey,
                            'Change Password',
                            () {
                              Navigator.of(context)
                                  .pushNamed(Routes.changePassword);
                            },
                          ),
                          _SettingItem(
                            AppIcons.settingUpdateAvatar,
                            'Update Your Avatar',
                                () {
                                Navigator.of(context).pushNamed(Routes.updateYourAvatar);
                            },
                          ),
                          _SettingItem(
                            AppIcons.settingLogout,
                            'Logout',
                            () {
                              _showLogoutDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 160,
                      child: _ProfileSection(
                        title: 'Support',
                        menu: [
                          _SettingItem(
                            AppIcons.settingUserGuide,
                            'User Guide',
                            () {
                              Navigator.of(context).pushNamed(Routes.userGuide);
                            },
                          ),
                          _SettingItem(
                            AppIcons.settingContactSupport,
                            'Contact Support',
                            () => _openEmailSupport(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 80,
                      child: _ProfileSection(
                        title: 'More',
                        menu: [
                          _SettingItem(
                            AppIcons.settingFeedback,
                            'Send Feedback',
                            () => Navigator.of(context)
                                .pushNamed(Routes.sendFeedback),
                          ),
                          // _SettingItem(
                          //   AppIcons.settingTermCondition,
                          //   'Term And Conditions',
                          //   () {},
                          // ),
                        ],
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
            ),
          ),
        ),
      ),
    );
  }

  _clearBlocData() {
    context.read<AppBottomBarBloc>().reset();
    context.read<StudyCubit>().reset();
    context.read<PatientTreatmentBloc>().reset();
    context.read<FormDetailCubit>().reset();
    context.read<PatientDocumentCubit>().reset();
    context.read<HomeBloc>().reset();
  }

  _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AppCustomDialog(
        parentContext: context,
        title: 'Confirmation',
        message: 'Are you sure you want to logout?',
        actionTitle: 'Yes',
        dismissTitle: 'No',
        onAction: ()  {
          context.read<ChatCubit>().logoutFirebase();
          context.read<AuthCubit>().logout();
        } ,
        onDismiss: () {},
      ),
    );
  }

  _openEmailSupport() async {
    String url = 'mailto:support@talosix.com?subject=Mobile App Support';
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showDefaultContactDialog();
      }
    } on Exception catch (_) {
      _showDefaultContactDialog();
    }
  }

  _showDefaultContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content:
              const Text('Please send an email to us: support@talosix.com'),
          actions: <Widget>[
            TextButton(
              child: const Text('Got It'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    Key? key,
    required this.title,
    required this.menu,
  }) : super(key: key);

  final String title;
  final List<_SettingItem> menu;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.w400s16black),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menu.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: menu[index].event,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  elevation: 0.5,
                ),
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage(menu[index].icon),
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      menu[index].title,
                      style: AppTextStyles.w400s16black,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _SettingItem {
  final String icon;
  final String title;
  final VoidCallback event;

  _SettingItem(
    this.icon,
    this.title,
    this.event,
  );
}


import 'package:flutter/material.dart';
import 'package:talosix/app/presentations/screens/auth_input_otp_screen.dart';
import 'package:talosix/app/presentations/screens/change_password_screen.dart';
import 'package:talosix/app/presentations/screens/confirm_forgot_password_screen.dart';
import 'package:talosix/app/presentations/screens/forgot_password_screen.dart';
import 'package:talosix/app/presentations/screens/form_detail_screen.dart';
import 'package:talosix/app/presentations/screens/form_list_screen.dart';
import 'package:talosix/app/presentations/screens/form_outline_screen.dart';
import 'package:talosix/app/presentations/screens/form_query_detail_screen.dart';
import 'package:talosix/app/presentations/screens/mfa_input_otp_screen.dart';
import 'package:talosix/app/presentations/screens/mfa_verify_success_screen.dart';
import 'package:talosix/app/presentations/screens/onboard_screen.dart';
import 'package:talosix/app/presentations/screens/profile_screen.dart';
import 'package:talosix/app/presentations/screens/request_register_account_screen.dart';
import 'package:talosix/app/presentations/screens/send_feedback_screen.dart';
import 'package:talosix/app/presentations/screens/term_and_condition_screen.dart';
import 'package:talosix/app/presentations/screens/update_your_avatar_screen.dart';
import 'package:talosix/app/presentations/screens/user_guide_screen.dart';

import '../../app/presentations/screens/app_bottom_bar.dart';
import '../../app/presentations/screens/confirm_account_screen.dart';
import '../../app/presentations/screens/login_screen.dart';
import '../../app/presentations/screens/mfa_input_phone_number_screen.dart';
import '../../app/presentations/screens/mfa_select_type_screen.dart';
import '../../app/presentations/screens/splash_screen.dart';
import '../presentations/screens/chat_list_screen.dart';
import '../presentations/screens/form_data_changed_list_screen.dart';
import 'routes.dart';

class AppRoutes {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();

  static Map<String, WidgetBuilder> routes = {};

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    WidgetBuilder? builder;

    switch (settings.name) {
      case Routes.splash:
        builder = (_) => const SplashScreen();
        break;
      case Routes.login:
        builder = (_) => LoginScreen();
        break;
      case Routes.changePassword:
        builder = (_) => ChangePasswordScreen();
        break;
      case Routes.forgotPassword:
        builder = (_) => ForgotPasswordScreen();
        break;
      case Routes.confirmForgotPassword:
        builder = (_) => ConfirmForgotPasswordScreen();
        break;
      case Routes.main:
        builder = (_) => const AppBottomBarScreen();
        break;
      case Routes.confirmAccount:
        builder = (_) => ConfirmAccountScreen();
        break;
      case Routes.mfaSelectType:
        builder = (_) => MfaSelectTypeScreen();
        break;
      case Routes.mfaInputPhoneNumber:
        builder = (_) => MfaInputPhoneNumberScreen();
        break;
      case Routes.mfaInputPhoneOtp:
        builder = (_) =>  const MfaInputOtpScreen(isPhoneOtp: true);
        break;
      case Routes.mfaInputMailOtp:
        builder = (_) =>  const MfaInputOtpScreen(isPhoneOtp: false);
        break;
      case Routes.mfaVerifySuccess:
        builder = (_) => const MfaVerifySuccessScreen();
        break;
      case Routes.authInputOtp:
        builder = (_) => const AuthInputOtpScreen();
        break;
      case Routes.termAndCondition:
        builder = (_) => const TermAndConditionScreen();
        break;
      case Routes.forms:
        builder = (_) => FormListScreen();
        break;
      case Routes.formDetail:
        builder = (_) => const FormDetailScreen();
        break;
      case Routes.setting:
        builder = (_) => const ProfileScreen();
        break;
      case Routes.formDataChanged:
        builder = (_) => const FormDataChangedListScreen();
        break;
      case Routes.formOutline:
        builder = (_) => const FormOutlineScreen();
        break;
      case Routes.onboard:
        builder = (_) => OnboardScreen();
        break;
      case Routes.userGuide:
        builder = (_) => const UserGuideScreen();
        break;
      case Routes.sendFeedback:
        builder = (_) => const SendFeedbackScreen();
        break;
      case Routes.requestRegisterAccount:
        builder = (_) => const RequestRegisterScreen();
        break;
      case Routes.formQueryDetail:
        builder = (_) => const FormQueryDetailScreen();
        break;
      case Routes.chatList:
        builder = (_) => const ChatListScreen();
        break;
      case Routes.updateYourAvatar:
        builder = (_) => const UpdateYourAvatarScreen();
        break;
      default:
        break;
    }

    if (builder != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: builder,
      );
    }
    return null;
  }
}

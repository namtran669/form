import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:talosix/app/blocs/chat/chat_cubit.dart';
import 'package:talosix/app/blocs/form_counter/form_counter_cubit.dart';
import 'package:talosix/app/blocs/form_incomplete/form_incomplete_bloc.dart';
import 'package:talosix/app/blocs/form_queries/form_queries_cubit.dart';
import 'package:talosix/app/blocs/mfa_auth/mfa_cubit.dart';
import 'package:talosix/app/blocs/navigation/navigation_cubit.dart';
import 'package:talosix/app/blocs/study_patient/study_cubit.dart';
import 'package:talosix/app/blocs/treatment/treatment_bloc.dart';
import 'package:talosix/app/blocs/user/user_profile_cubit.dart';
import 'package:talosix/app/constants/app_colors.dart';
import 'package:talosix/app/constants/app_constants.dart';
import 'package:talosix/app/routes/app_routes.dart';
import 'package:talosix/app/routes/routes.dart';

import '../di/locator.dart';
import 'blocs/app_bottom_bar/app_bottom_bar_bloc.dart';
import 'blocs/auth/auth_cubit.dart';
import 'blocs/form_question/form_detail_cubit.dart';
import 'blocs/form_validator/app_form_cubit.dart';
import 'blocs/patient_document/patient_document_cubit.dart';

class DataFlowApp extends StatelessWidget {
  const DataFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<AuthCubit>()),
        BlocProvider(create: (_) => locator<AppFormCubit>()),
        BlocProvider(create: (_) => locator<AppBottomBarBloc>()),
        BlocProvider(create: (_) => locator<MfaCubit>()),
        BlocProvider(create: (_) => locator<AppUserProfileCubit>()),
        BlocProvider(create: (_) => locator<NavigationCubit>()),
        BlocProvider(create: (_) => locator<StudyCubit>()),
        BlocProvider(create: (_) => locator<PatientTreatmentBloc>()),
        BlocProvider(create: (_) => locator<FormDetailCubit>()),
        BlocProvider(create: (_) => locator<PatientDocumentCubit>()),
        BlocProvider(create: (_) => locator<HomeBloc>()),
        BlocProvider(create: (_) => locator<FormCounterCubit>()),
        BlocProvider(create: (_) => locator<FormQueriesCubit>()),
        BlocProvider(create: (_) => locator<ChatCubit>()),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Strings.init(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: Strings.tr.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: AppConstants.fontFamily,
          primaryColor: AppColors.dodgerBlue,
        ),
        locale: const Locale('en', ''),
        supportedLocales: AppLocalizationsDelegate.supportedLocales,
        localizationsDelegates: const [
          AppLocalizationsDelegate.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        navigatorKey: AppRoutes.navigatorKey,
        navigatorObservers: [
          AppRoutes.routeObserver,
        ],
        initialRoute: Routes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _timer?.cancel();
        break;
      case AppLifecycleState.inactive:
        _startCountdownToLogout();
        break;
      case AppLifecycleState.paused:
        _startCountdownToLogout();
        break;
      case AppLifecycleState.detached:
        _logout();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _startCountdownToLogout() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 20), (timer) {
      _logout();
    });
  }

  _logout() {
    context.read<ChatCubit>().logoutFirebase();
    context.read<AuthCubit>().logout();
  }
}

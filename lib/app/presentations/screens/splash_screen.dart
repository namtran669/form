import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/blocs/navigation/navigation_cubit.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../styles/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () async {
      context.read<NavigationCubit>().checkUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, NavigationState>(
      listener: (context, state) {
        if (state is NavigationNextRoute) {
          Navigator.of(context).pushReplacementNamed(state.nextRoute);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                AppImages.appIcon,
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Talosix',
                style: AppTextStyles.w500s24pictonBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

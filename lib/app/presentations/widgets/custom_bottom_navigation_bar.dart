import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/constants/app_images.dart';

import '../../blocs/app_bottom_bar/app_bottom_bar_bloc.dart';
import '../../constants/app_colors.dart';
import '../../styles/app_styles.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  final unselectedItemColor = Colors.grey;
  final selectedItemColor = Colors.blue;
  final unselectedBackground = Colors.transparent;
  final selectedBackground = AppColors.fog;

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<AppBottomBarBloc>().state;
    bool isHomeSelected = currentIndex == BottomBarIndex.home;
    bool isPatientSelected = currentIndex == BottomBarIndex.patient;
    bool isProfileSelected = currentIndex == BottomBarIndex.profile;
    bool isQuerySelected = currentIndex == BottomBarIndex.queries;
    bool isChatSelected = currentIndex == BottomBarIndex.chat;

    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex.index,
        onTap: (index) => context
            .read<AppBottomBarBloc>()
            .changeTab(BottomBarIndex.values[index]),
        items: [
          CustomBottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
                color: isHomeSelected ? selectedItemColor : unselectedItemColor,
              ),
              label: Text(
                Strings.tr.home,
                style: isHomeSelected
                    ? AppTextStyles.w400s12blue
                    : AppTextStyles.w400s12grey,
              ),
              backgroundSelectedColor:
                  isHomeSelected ? selectedBackground : unselectedBackground),
          CustomBottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppIcons.nvPatient),
                  color: isPatientSelected
                      ? selectedItemColor
                      : unselectedItemColor),
              label: Text(
                Strings.tr.patients,
                style: isPatientSelected
                    ? AppTextStyles.w400s12blue
                    : AppTextStyles.w400s12grey,
              ),
              backgroundSelectedColor: isPatientSelected
                  ? selectedBackground
                  : unselectedBackground),
          CustomBottomNavigationBarItem(
            icon: Icon(CupertinoIcons.question_circle,
                color:
                    isQuerySelected ? selectedItemColor : unselectedItemColor),
            label: Text(
              Strings.tr.query,
              style: isQuerySelected
                  ? AppTextStyles.w400s12blue
                  : AppTextStyles.w400s12grey,
            ),
            backgroundSelectedColor:
                isQuerySelected ? selectedBackground : unselectedBackground,
          ),
          CustomBottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text,
                color:
                isChatSelected ? selectedItemColor : unselectedItemColor),
            label: Text(
              Strings.tr.chat,
              style: isChatSelected
                  ? AppTextStyles.w400s12blue
                  : AppTextStyles.w400s12grey,
            ),
            backgroundSelectedColor:
            isChatSelected ? selectedBackground : unselectedBackground,
          ),
          CustomBottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppIcons.profile),
                  color: isProfileSelected
                      ? selectedItemColor
                      : unselectedItemColor),
              label: Text(
                Strings.tr.profile,
                style: isProfileSelected
                    ? AppTextStyles.w400s12blue
                    : AppTextStyles.w400s12grey,
              ),
              backgroundSelectedColor: isProfileSelected
                  ? selectedBackground
                  : unselectedBackground),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  static const iconSize = 25.0;
  static const iconSizeCenter = 50.0;

  CustomBottomNavigationBarItem({
    double iconSize = iconSize,
    Color backgroundSelectedColor = Colors.transparent,
    required Widget icon,
    required Text label,
  }) : super(
          label: '',
          icon: Container(
            width: 80,
            height: iconSizeCenter,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              color: backgroundSelectedColor,
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: icon,
                ),
                const SizedBox(height: 3),
                label,
              ],
            ),
          ),
        );
}

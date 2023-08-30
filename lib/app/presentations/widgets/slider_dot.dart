import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class SliderDot extends StatelessWidget {
  late final bool isActive;
  SliderDot(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: 21,
      width: 21,
      decoration: BoxDecoration(
        color: isActive ? AppColors.dodgerBlue : AppColors.concrete,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// AppTextStyle format as follows:
/// [fontWeight][fontSize][colorName][opacity]
/// Example: bold18White05
///
class AppTextStyles {
  static TextStyle title = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static const TextStyle _kNormal4 = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _kNormal5 = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _kNormal6 = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle w400s12grey = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s12blue = TextStyle(
    color: Colors.blue,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s10white = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s10grey = TextStyle(
    color: Colors.grey,
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static TextStyle w400s12grey500Italic = TextStyle(
    color: Colors.grey.withOpacity(0.5),
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle w400s16black = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s24black = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s15white = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s15black = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w600s15black = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle w400s15eggWhite = TextStyle(
    color: Colors.brown,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s15deepSapphire = TextStyle(
    color: AppColors.deepSapphire,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s16white = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s16grey = TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s16red = TextStyle(
    color: Colors.red,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s14dodgerBlue = TextStyle(
    color: AppColors.dodgerBlue,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s14blueDodger = TextStyle(
    color: AppColors.blueDodger,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s14white = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s13black = TextStyle(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s14black = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s14grey = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );



  static const TextStyle w400s16rhino = TextStyle(
    color: AppColors.rhino,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s15orangeAccent = TextStyle(
    color: Colors.orangeAccent,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static TextStyle w400s15grey400 = TextStyle(
    color: Colors.grey.shade400,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static TextStyle w400s15dustyGrey06 = TextStyle(
    color: AppColors.dustyGray.withOpacity(0.6),
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w400s18black = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle w500s13grey = TextStyle(
    color: Colors.grey,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s14grey = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s14black54 = TextStyle(
    color: Colors.black54,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s14black = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s16black = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s16white = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s15white = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s15black = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s16dodgerBlue = TextStyle(
    color: AppColors.dodgerBlue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s20dodgerBlue = TextStyle(
    color: AppColors.dodgerBlue,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s18black = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s18holly = TextStyle(
    color: AppColors.holly,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s18blueDodger = TextStyle(
    color: AppColors.blueDodger,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s20black = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s22black = TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s16black87 = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s14neptune = TextStyle(
    color: AppColors.neptune,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w500s24pictonBlue = TextStyle(
    color: AppColors.pictonBlue,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle w600s16black = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle w600s18red = TextStyle(
    color: Colors.red,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle w600s18midnightBlue = TextStyle(
    color: AppColors.midnightBlue,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle w600s18blueDodger = TextStyle(
    color: AppColors.blueDodger,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle w600s20black = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle w700s16white = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle w700s18white = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle w700s24black = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle w700s36white = TextStyle(
    color: Colors.white,
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle _kNormal6Black87 = _kNormal6.copyWith(
    color: Colors.black87,
  );

  static final TextStyle _kNormal4Black87 = _kNormal4.copyWith(
    color: Colors.black87,
  );

  static final TextStyle _kNormal5White = _kNormal5.copyWith(
    color: Colors.white,
  );

  static final TextStyle _kNormal5Black = _kNormal5.copyWith(
    color: Colors.black,
  );

  static final TextStyle _kNormal4Gold = _kNormal4.copyWith(
    color: AppColors.buddhaGold,
  );

  static final TextStyle kNormal4GoldSize13 =
      _kNormal4Gold.copyWith(fontSize: 13);

  static final TextStyle kNormal5BlackSize13 =
      _kNormal5Black.copyWith(fontSize: 13);

  static final TextStyle kNormal5DustyGraySize13 =
      kNormal5BlackSize13.copyWith(fontSize: 13);

  static final TextStyle kNormal5WhiteSize13 =
      _kNormal5White.copyWith(fontSize: 13);

  static final TextStyle kNormal4Black87Size10 = _kNormal4Black87.copyWith(
    fontSize: 10,
  );

  static final TextStyle kNormal4Black87Size16 = _kNormal4Black87.copyWith(
    fontSize: 16,
  );
  static final TextStyle kNormal4Black87Size13 = _kNormal6Black87.copyWith(
    fontSize: 13,
  );

  static final TextStyle _kNormal6Black = _kNormal6.copyWith(
    color: Colors.black,
  );

  static final TextStyle kNormal6BlackSize20 = _kNormal6Black.copyWith(
    fontSize: 20,
  );
}

class AppTextFieldStyle {
  static final borderNormal = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.grey,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(8),
  );

  static final borderFocused = OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColors.dodgerBlue,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(8),
  );

  static final borderError = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.red,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(8),
  );

  static final inputDisable = InputDecoration(
    border: borderNormal,
    fillColor: AppColors.wildSand,
  );

  static final inputEnable = InputDecoration(
    border: borderNormal,
    focusedBorder: borderFocused,
    fillColor: Colors.white,
  );
}

class AppButtonStyles {
  static final ButtonStyle r40blueDodger = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      AppColors.blueDodger,
    ),
  );
}

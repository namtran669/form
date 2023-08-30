import 'package:flutter/cupertino.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../ui_model/form_query_status.dart';

class QueryStatusView extends StatelessWidget {
  const QueryStatusView({
    Key? key,
    required this.status,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.iconWidth,
    required this.iconHeight,
    required this.fontSize,
  }) : super(key: key);

  final FormQueryStatus status;
  final double verticalPadding;
  final double horizontalPadding;
  final double iconWidth;
  final double iconHeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String icon;

    switch (status) {
      case FormQueryStatus.open:
        statusColor = AppColors.blazeOrange;
        icon = AppIcons.formQueryOpen;
        break;
      case FormQueryStatus.approved:
        statusColor = AppColors.shamrock;
        icon = AppIcons.formQueryApproved;
        break;
      case FormQueryStatus.rejected:
        statusColor = AppColors.flamingo;
        icon = AppIcons.formQueryRejected;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: iconWidth,
            height: iconHeight,
          ),
          const SizedBox(width: 3),
          Text(
            status.name,
            style: TextStyle(
              color: statusColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/blocs/form_queries/form_queries_cubit.dart';
import 'package:talosix/app/constants/app_images.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';
import 'package:talosix/app/styles/app_styles.dart';

import '../../constants/app_colors.dart';
import '../../ui_model/form_query_status.dart';

class QueryFilterStatusView extends StatefulWidget {
  const QueryFilterStatusView({Key? key}) : super(key: key);


  @override
  State<QueryFilterStatusView> createState() => _QueryFilterStatusViewState();
}

class _QueryFilterStatusViewState extends State<QueryFilterStatusView> {
  var currentFilter = FormQueryFilter.all;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Widget icon;

    switch (currentFilter) {
      case FormQueryFilter.all:
        statusColor = AppColors.blueDodger;
        icon = const Icon(
          Icons.check,
          color: AppColors.blueDodger,
          size: 15,
        );
        break;
      case FormQueryFilter.open:
        statusColor = AppColors.blazeOrange;
        icon = Image.asset(
          AppIcons.formQueryOpen,
          width: 15,
          height: 15,
        );
        break;
      case FormQueryFilter.approved:
        statusColor = AppColors.shamrock;
        icon = Image.asset(
          AppIcons.formQueryApproved,
          width: 15,
          height: 15,
        );
        break;
      case FormQueryFilter.rejected:
        statusColor = AppColors.flamingo;
        icon = Image.asset(
          AppIcons.formQueryRejected,
          width: 15,
          height: 15,
        );
        break;
    }

    return GestureDetector(
      onTap: () {
        showAdaptiveActionSheet(
          context: context,
          title: const Text(
            'Filter Query By Status',
            style: AppTextStyles.w600s16black,
          ),
          actions: filterActions(context),
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 150,
          maxHeight: double.infinity,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          child: Row(
            children:  [
             icon,
              const SizedBox(width: 5),
              Text(
                currentFilter.name,
                style: TextStyle(color: statusColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<BottomSheetAction> filterActions(BuildContext context) {
    List<BottomSheetAction> actions = [];
    for (var filter in FormQueryFilter.values) {
      actions.add(
        BottomSheetAction(
          title: Row(
            children: [
              Text(
                filter.name,
                style: AppTextStyles.w400s16black,
              ),
              const Spacer()
            ],
          ),
          onPressed: (_) {
            setState(() {
              currentFilter = filter;
              context
                  .read<FormQueriesCubit>()
                  .filterAssignedQueriesByStatus(filter);
              Navigator.of(context).pop();
            });
          },
          trailing: currentFilter == filter
              ? const Icon(
                  Icons.check,
                  color: Colors.blueAccent,
                )
              : emptyBox,
        ),
      );
    }
    return actions;
  }
}

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/blocs/study_patient/study_cubit.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/constants/app_images.dart';

import '../../constants/app_colors.dart';

class StudyView extends StatelessWidget {
  const StudyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAdaptiveActionSheet(
          context: context,
          title: const Text(
            'Select a study',
            style: AppTextStyles.w600s16black,
          ),
          actions: studyActions(context),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 150, maxHeight: double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cornFlowerBlue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(0, 1))
          ],
          gradient: const LinearGradient(
              colors: [AppColors.royalBlue, AppColors.cornFlowerBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: FittedBox(
          child: Row(
            children: [
              ImageIcon(AssetImage(AppIcons.study), color: Colors.white, size: 15),
              const SizedBox(width: 5),
              BlocBuilder<StudyCubit, StudyState>(
                builder: (context, state) {
                  String studyName = '';
                  if (state is StudySelected) {
                    studyName = state.study.name;
                  }
                  return Text(
                    studyName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BottomSheetAction> studyActions(BuildContext context) {
    List<BottomSheetAction> actions = [];
    var cubit = context.read<StudyCubit>();
    List<Study> studies = cubit.studies;
    for (var study in studies) {
      actions.add(
        BottomSheetAction(
          title: Row(
            children: [
              Text(
                study.name,
                style: AppTextStyles.w400s16black,
              ),
              const Spacer()
            ],
          ),
          onPressed: (_) {
            cubit.selectStudy(study);
            Navigator.of(context).pop();
          },
          trailing: cubit.studySelected == study
              ? const Icon(Icons.check, color: Colors.blueAccent)
              : null,
        ),
      );
    }
    return actions;
  }
}

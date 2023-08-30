import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/styles/app_styles.dart';

import '../../blocs/study_patient/study_cubit.dart';
import '../../blocs/treatment/treatment_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/bottom_loader.dart';
import '../widgets/study_view.dart';

class PatientTreatmentsScreen extends StatefulWidget {
  const PatientTreatmentsScreen({Key? key}) : super(key: key);

  @override
  State<PatientTreatmentsScreen> createState() => _PatientTreatmentsScreenState();
}

class _PatientTreatmentsScreenState extends State<PatientTreatmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    Strings.tr.patients,
                    style: AppTextStyles.w500s20dodgerBlue,
                  ),
                  const Spacer(),
                  const StudyView(),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Find and submit forms for patients.',
                style: TextStyle(
                  color: AppColors.rhino.withOpacity(0.54),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: BlocBuilder<StudyCubit, StudyState>(
                  builder: (context, state) {
                    if (state is StudySelected) {
                      return PatientTreatmentList(study: state.study);
                    } else {
                      return const Center(child: Text('Please select a study'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientTreatmentList extends StatefulWidget {
  const PatientTreatmentList({Key? key, required this.study}) : super(key: key);
  final Study study;

  @override
  State<PatientTreatmentList> createState() => _PatientTreatmentListState();
}

class _PatientTreatmentListState extends State<PatientTreatmentList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientTreatmentBloc, PatientTreatmentState>(
      builder: (context, state) {
        switch (state.status) {
          case LoadMoreStatus.success:
            if (state.treatments.isEmpty) {
              return const Center(child: Text('Treatment is empty.'));
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                state.treatments.length;
                return index >= state.treatments.length
                    ? const BottomLoader()
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.forms,
                            arguments: state.treatments[index],
                          );
                        },
                        child: PatientTreatmentItem(
                          treatment: state.treatments[index],
                        ),
                      );
              },
              itemCount: state.hasReachedMax
                  ? state.treatments.length
                  : state.treatments.length + 1,
              controller: _scrollController,
            );
          case LoadMoreStatus.failure:
            return const Center(
                child: Text('Can not load treatment, please try again'));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PatientTreatmentBloc>().add(TreatmentFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}

class PatientTreatmentItem extends StatelessWidget {
  final Treatment treatment;

  const PatientTreatmentItem({Key? key, required this.treatment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        treatment.patient!.id.toString(),
                        style: AppTextStyles.w500s16dodgerBlue,
                      ),
                      Text(
                        ' - ${treatment.patient!.name}',
                        style: AppTextStyles.w500s16black87,
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Image.asset(AppIcons.treatmentIcon, width: 20, height: 20),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          treatment.name ?? '',
                          style: AppTextStyles.w500s16black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Image.asset(AppIcons.treatmentDateIcon, width: 20, height: 20),
                      const SizedBox(width: 5),
                      Text(
                        treatment.date ?? '',
                        style: AppTextStyles.w500s16black87,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}

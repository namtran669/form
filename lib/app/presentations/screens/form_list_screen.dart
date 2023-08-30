import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../blocs/form_question/form_detail_cubit.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../../ui_model/form_query_status.dart';
import '../../ui_model/transfer_custom_data_model.dart';
import '../widgets/common_view.dart';

class FormListScreen extends StatelessWidget {
  FormListScreen({Key? key}) : super(key: key);

  final List<FormQueryDetails> queriesForm = [];

  @override
  Widget build(BuildContext context) {
    var treatment = ModalRoute.of(context)!.settings.arguments as Treatment;
    var formsData = treatment.formData;
    FormDetailCubit formDetailCubit = context.read<FormDetailCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '${treatment.patient?.id} - ${treatment.patient?.name}',
          style: AppTextStyles.w500s18holly,
        ),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: BlocConsumer<FormDetailCubit, FormDetailState>(
        listener: (ctx, state) async {
          if (state is FormDetailSuccess) {
            Navigator.of(ctx).pushNamed(
              Routes.formDetail,
              arguments: _getFormComponentWithQueries(state, formsData),
            );
          } else if (state is FormDetailError) {
            ctx.showMessage(
              ToastMessageType.error,
              state.msg,
            );
          }
        },
        builder: (context, state) {
          if (state is FormListFetched) {
            formsData = state.forms;
            queriesForm
              ..clear()
              ..addAll(state.queries);
          }
          return VisibilityDetector(
            key: const Key('FormListScreen'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction == 1) {
                formDetailCubit.fetchFormsByPatientTreatmentId(treatment.id);
              }
            },
            child: LoadingOverlay(
              isLoading: state is FormListFetching,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: RefreshIndicator(
                  onRefresh: () async {
                    formDetailCubit.fetchFormsByPatientTreatmentId(
                      treatment.id,
                    );
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        BlocBuilder<FormDetailCubit, FormDetailState>(
                      builder: (context, state) {
                        if (state is FormDetailProcessing) {
                          if (state.id == formsData[index].id) {
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }
                        FormData formData = formsData[index];
                        return GestureDetector(
                          onTap: () => context
                              .read<FormDetailCubit>()
                              .fetchForm(formData.id),
                          child: FormDataItem(
                            formData: formData,
                            queries: _filterQueriesByFormId(formData.formId),
                          ),
                        );
                      },
                    ),
                    itemCount: formsData.length,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<FormQueryDetails> _filterQueriesByFormId(int formId) {
    List<FormQueryDetails> formQueries = [];
    if (queriesForm.isNotEmpty) {
      for (var query in queriesForm) {
        if (query.formData?.formId == formId) {
          formQueries.add(query);
        }
      }
    }
    return formQueries;
  }

  FormComponentWithQueries _getFormComponentWithQueries(
    FormDetailSuccess state,
    List<FormData> formsData,
  ) {
    List<FormQueryDetails> queries = [];
    for (var form in formsData) {
      if (form.id == state.component.id) {
        queries = _filterQueriesByFormId(form.formId);
        state.component.formTypeName = form.formTypeName;
        state.component.deleting = form.deleting;
        state.component.patientDeleting = form.patientDeleting;
      }
    }
    return FormComponentWithQueries(state.component, queries);
  }
}

class FormDataItem extends StatelessWidget {
  const FormDataItem({
    Key? key,
    required this.formData,
    this.queries,
  }) : super(key: key);

  final FormData formData;
  final List<FormQueryDetails>? queries;

  @override
  Widget build(BuildContext context) {
    String? startDate = '';
    String? endDate = '';
    bool shouldShowDate = ['pef', 'pro'].contains(formData.formTypeName);
    if (shouldShowDate) {
      startDate = formData.startDate.split('T')[0];
      endDate = formData.endDate.split('T')[0];
    }
    Color statusColor;
    switch (formData.formDataStatusId) {
      case 1:
        statusColor = const Color.fromRGBO(255, 1, 14, 1);
        break;
      case 2:
        statusColor = Colors.blueAccent;
        break;
      case 3:
        statusColor = const Color.fromRGBO(52, 191, 150, 1);
        break;
      case 4:
        statusColor = Colors.cyan;
        break;
      case 5:
        statusColor = const Color.fromRGBO(255, 70, 114, 1);
        break;
      case 6:
        statusColor = const Color.fromRGBO(53, 84, 82, 1);
        break;
      case 7:
        statusColor = const Color.fromRGBO(168, 57, 223, 1);
        break;
      case 8:
        statusColor = const Color.fromRGBO(145, 91, 0, 1);
        break;
      case 9:
        statusColor = const Color.fromRGBO(70, 162, 206, 1);
        break;
      case 10:
        statusColor = const Color.fromRGBO(127, 143, 164, 1);
        break;
      case 11:
        statusColor = const Color.fromRGBO(108, 117, 125, 1);
        break;
      case 12:
        statusColor = const Color.fromRGBO(70, 162, 206, 1);
        break;
      case 13:
        statusColor = const Color.fromRGBO(220, 53, 69, 1);
        break;
      default:
        statusColor = Colors.grey;
        break;
    }

    return BlocBuilder<FormDetailCubit, FormDetailState>(
      builder: (context, state) {
        if (state is FormDetailProcessing) {
          if (state.id == formData.id) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
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
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 27,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                formData.statusName,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formData.formTypeName.toUpperCase(),
                            style: AppTextStyles.w400s16black,
                          ),
                          const SizedBox(width: 10),
                          _queryStatusView(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        formData.formName,
                        style: AppTextStyles.w500s16black87,
                      ),
                      const SizedBox(height: 16),
                      shouldShowDate
                          ? Text(
                              '$startDate to $endDate',
                              style: AppTextStyles.w500s14black54,
                            )
                          : emptyBox,
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 15,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _queryStatusView() {
    if (queries != null) {
      for (var query in queries!) {
        var status = FormQueryStatusExt.createFromString(query.status);
        if (status == FormQueryStatus.open) {
          return Image.asset(
            AppIcons.formQueryOpen,
            width: 20,
            height: 20,
          );
        }
      }
    }
    return emptyBox;
  }
}

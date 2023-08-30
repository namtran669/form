import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/blocs/form_queries/form_queries_cubit.dart';
import 'package:talosix/app/blocs/form_question/form_detail_cubit.dart';
import 'package:talosix/app/constants/app_images.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/screens/form_outline_screen.dart';
import 'package:talosix/app/presentations/widgets/custom_app_dialog.dart';
import 'package:talosix/app/presentations/widgets/form_query_button.dart';
import 'package:talosix/app/presentations/widgets/form_view_template.dart';
import 'package:talosix/app/routes/routes.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/ui_model/form_type.dart';

import '../../blocs/patient_document/patient_document_cubit.dart';
import '../../constants/app_colors.dart';
import '../../ui_model/form_query_status.dart';
import '../../ui_model/transfer_custom_data_model.dart';
import '../widgets/common_view.dart';

class FormDetailScreen extends StatefulWidget {
  const FormDetailScreen({Key? key}) : super(key: key);

  @override
  State<FormDetailScreen> createState() => _FormDetailScreenState();
}

class _FormDetailScreenState extends State<FormDetailScreen> {
  late PageController pageController;
  late int page;
  late FormComponentResponse formData;
  late List<FormQueryDetails> queries;

  @override
  void initState() {
    super.initState();
    // clear uploaded file when opening a new form
    context.read<PatientDocumentCubit>().reset();
    pageController = PageController();
    page = 0;
  }

  @override
  Widget build(BuildContext context) {
    var formDetailCubit = context.read<FormDetailCubit>();
    var patientDocumentCubit = context.read<PatientDocumentCubit>();
    var formQueriesCubit = context.read<FormQueriesCubit>();

    var formDataWithQueries =
        ModalRoute.of(context)!.settings.arguments as FormComponentWithQueries;
    formData = formDataWithQueries.components;
    queries = formDataWithQueries.queries;
    if (queries.isNotEmpty) {
      formQueriesCubit.emitNewQueries(queries);
      formDetailCubit.assignFormQueries(queries);
    } else {
      formQueriesCubit.fetchQueriesByFormDataId(formData.id);
    }

    int maxPage = formData.form?.formElements?.components.length ?? 0;
    FormType formType = FormTypeExt.createFromString(formData.formTypeName);
    bool isEditable = _isFormEditable();
    bool isSavable = _isFormSavable();
    formDetailCubit.checkFormDeletion(formData);
    patientDocumentCubit.checkDocumentByFormId(
      formData.id,
      formData.documentAttachment ?? [],
    );

    return BlocConsumer<FormDetailCubit, FormDetailState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is FormDetailSubmitDataProcessing,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (isEditable &&
                        isSavable &&
                        formDetailCubit.hasDataChange()) {
                      _showConfirmQuitDialog(context);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                title: FittedBox(
                  child: Text(
                    formType.name,
                    style: AppTextStyles.w500s18holly,
                  ),
                ),
                centerTitle: false,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [
                  isEditable
                      ? Row(
                          children: [
                            isSavable
                                ? IconButton(
                                    onPressed: () => formDetailCubit.saveForm(),
                                    icon: ImageIcon(
                                      AssetImage(AppIcons.formSave),
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  )
                                : emptyBox,
                            IconButton(
                              onPressed: () {
                                formDetailCubit.checkDataChangedAndSubmit();
                              },
                              icon: ImageIcon(
                                AssetImage(AppIcons.formSubmit),
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     context
                            //     .read<FormDetailCubit>()
                            //     .checkUnansweredAndSubmit();
                            //   },
                            //   icon: ImageIcon(
                            //     AssetImage(AppIcons.moreHorizontal),
                            //     color: Colors.blue,
                            //     size: 20,
                            //   ),
                            // ),
                          ],
                        )
                      : emptyBox
                ]),
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                formData.form!.name,
                                style: AppTextStyles.w500s22black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),
                          FormQueryButton(
                            question: Text(
                              formData.form!.name,
                              style: AppTextStyles.w400s16black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _FormDetailBody(
                          controller: pageController,
                          formData: formData,
                          queries: queries,
                          isFormEditable: isEditable,
                          onPageChanged: (current) {
                            setState(() {
                              page = current;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.white,
              height: 65,
              child: _FormDetailBottomController(
                onNextPressed: () {
                  if (page < maxPage - 1) {
                    setState(() {
                      page++;
                      pageController.animateToPage(
                        page,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    });
                  } else {
                    if (isEditable) {
                      formDetailCubit.checkDataChangedAndSubmit();
                    }
                  }
                },
                onBackPressed: () {
                  if (page > 0) {
                    setState(() {
                      page--;
                      pageController.animateToPage(
                        page,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    });
                  }
                },
                onOutlinePressed: () async {
                  var pageOutline = await Navigator.of(context).pushNamed(
                    Routes.formOutline,
                    arguments: _getOutlineData(),
                  );
                  if (pageOutline != null) {
                    page = (pageOutline as int) - 1;
                    pageController.jumpToPage(page);
                  }
                },
                title: 'Page ${page + 1} / $maxPage',
                isLastPage: page == maxPage - 1,
                enablePrev: page > 0,
                enableSubmit: isEditable,
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is FormDetailError) {
          context.showMessage(
            ToastMessageType.error,
            state.msg,
          );
        } else if (state is FormDetailSaveSuccess) {
          context.showMessage(
            ToastMessageType.message,
            'Success! Responses have been saved.',
          );
          if (state.isShouldPop) {
            Navigator.of(context).pop();
          }
        } else if (state is FormDetailSubmitSuccess) {
          context.showMessage(
            ToastMessageType.message,
            'Success! Responses have been saved.',
          );
          Navigator.of(context).pop();
        } else if (state is FormDetailValidateEligible) {
          context.showMessage(
            ToastMessageType.error,
            'Please answer all the eligibility question before submitting.',
          );
        } else if (state is FormDetailPatientIneligible) {
          context.showMessage(
            ToastMessageType.error,
            'This patient is ineligible. Please add a Treatment '
            'deletion request as this patient needs '
            'to be removed from the study',
          );
        } else if (state is FormDetailDeletion) {
          if (state.shouldShowMessage) {
            context.showMessage(
              ToastMessageType.warning,
              'This form is disabled for editing, as a request for its deletion '
              'is pending approval. Please contact Study Manager for more information.',
            );
          }
        } else if (state is FormDetailRequireUnanswered) {
          Navigator.of(context).pushNamed(
            Routes.formDataChanged,
            arguments: FormDataChangedWithType(
              state.unanswered,
              FormDataChangedType.unanswered,
            ),
          );
        } else if (state is FormDetailRequireQueryModifyReason) {
          Navigator.of(context).pushNamed(
            Routes.formDataChanged,
            arguments: FormDataChangedWithType(
              state.modifyList,
              FormDataChangedType.changeQuery,
            ),
          );
        }
      },
    );
  }

  bool _isFormEditable() {
    bool isFormStatusValid = false;
    switch (formData.statusName) {
      case 'active':
      case 'incomplete':
      case 'complete':
      case 'about_to_expire':
        isFormStatusValid = true;
        break;
    }

    bool isFormLockStatusValid = false;
    bool isDeleting =
        (formData.deleting ?? false) || (formData.patientDeleting ?? false);
    if (!isDeleting && [0, 1].contains(formData.lockStatus)) {
      isFormLockStatusValid = true;
    }

    bool isFormStartEndDateValid = true;
    try {
      DateTime startDate = DateTime.parse(formData.startDate);
      DateTime endDate = DateTime.parse(formData.endDate);
      isFormStartEndDateValid =
          DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
    } on Exception catch (_) {}

    return isFormStatusValid &&
        isFormLockStatusValid &&
        isFormStartEndDateValid;
  }

  bool _isFormDeleting() {
    return (formData.deleting ?? false) || (formData.patientDeleting ?? false);
  }

  bool _isFormLock() {
    return formData.lockStatus == 1;
  }

  bool _isFormSavable() {
    return ['active', 'incomplete'].contains(formData.statusName);
  }

  FormOutlineData _getOutlineData() {
    List<FormOutline> outlines = [];
    formData.form?.formElements?.components.asMap().forEach((index, component) {
      outlines.add(FormOutline(component.title));
    });

    return FormOutlineData(formData.form!.name, outlines);
  }

  _showConfirmQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppCustomDialog(
        parentContext: context,
        title: 'Unsaved changes',
        message: 'Your form has unsaved changes. '
            'Discard changes, or save changes to continue.',
        actionTitle: 'Save',
        dismissTitle: 'Discard',
        onAction: () => context.read<FormDetailCubit>().saveForm(
              isShouldPopScreen: true,
            ),
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _FormDetailBottomController extends StatelessWidget {
  const _FormDetailBottomController({
    Key? key,
    required this.onNextPressed,
    required this.onBackPressed,
    required this.onOutlinePressed,
    required this.title,
    required this.enablePrev,
    required this.isLastPage,
    required this.enableSubmit,
  }) : super(key: key);

  final VoidCallback onNextPressed, onBackPressed, onOutlinePressed;
  final String title;
  final bool enablePrev, isLastPage, enableSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: enablePrev
                ? SizedBox(
                    height: double.infinity,
                    child: ElevatedButton(
                      onPressed: onBackPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.arrow_back_ios_new, size: 16),
                          Text(
                            'Prev',
                            style: AppTextStyles.w500s15white,
                          ),
                        ],
                      ),
                    ),
                  )
                : emptyBox,
          ),
          const SizedBox(width: 3),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: double.infinity,
              child: ElevatedButton(
                onPressed: onOutlinePressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage(AppIcons.outline),
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 3),
                    Text(title, style: AppTextStyles.w500s15white),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            flex: 3,
            child: _getNextButton(),
          ),
        ],
      ),
    );
  }

  Widget _getNextButton() {
    if (isLastPage) {
      if (!enableSubmit) return emptyBox;
      return SizedBox(
        height: double.infinity,
        child: ElevatedButton(
          onPressed: onNextPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage(AppIcons.formSubmit),
                color: Colors.white,
                size: 16,
              ),
              const Text(
                'Submit',
                style: AppTextStyles.w500s15white,
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: double.infinity,
        child: ElevatedButton(
          onPressed: onNextPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Next',
                style: AppTextStyles.w500s15white,
              ),
              Icon(Icons.arrow_forward_ios, size: 15)
            ],
          ),
        ),
      );
    }
  }
}

class _FormDetailBody extends StatelessWidget {
  const _FormDetailBody({
    Key? key,
    required this.controller,
    required this.formData,
    required this.isFormEditable,
    required this.onPageChanged,
    required this.queries,
  }) : super(key: key);

  final FormComponentResponse formData;
  final PageController controller;
  final bool isFormEditable;
  final ValueChanged<int> onPageChanged;
  final List<FormQueryDetails> queries;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: (page) => onPageChanged.call(page),
      controller: controller,
      itemCount: formData.form?.formElements?.components.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getFormElement(index, isFormEditable, queries),
          ),
        );
      },
    );
  }

  List<Widget> getFormElement(
    int index,
    bool isFormEditable,
    List<FormQueryDetails> queries,
  ) {
    List<Widget> widgets = [];
    var component = formData.form!.formElements!.components[index];
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(component.title, style: AppTextStyles.w400s18black),
          const SizedBox(width: 3),
          FormQueryButton(
            queryKey: component.key,
            question: Text(
              component.title,
              style: AppTextStyles.w400s16black,
            ),
          ),
        ],
      ),
    );

    for (ComponentDetail detail in component.components) {
      bool isQueryValid = true;
      for (var query in queries) {
        if (query.questionKey == detail.key) {
          var status = FormQueryStatusExt.createFromString(query.status);
          isQueryValid = status.name != FormQueryStatus.approved.name;
        }
      }
      widgets.add(
        FormViewTemplate(
          detail: detail,
          formData: formData,
          editable: isQueryValid && isFormEditable,
        ),
      );
    }
    return widgets;
  }
}

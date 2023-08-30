import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:talosix/app/ui_model/form_type.dart';

import '../../ui_model/form_query_status.dart';

part 'form_detail_state.dart';

class FormDetailCubit extends Cubit<FormDetailState> {
  FormDetailCubit(
    this._patientTreatmentRepo,
    this._patientDocumentRepo,
    this._formQueriesRepo,
  ) : super(FormDetailInitial());

  final PatientTreatmentRepo _patientTreatmentRepo;
  final PatientDocumentRepo _patientDocumentRepo;
  final FormQueriesRepo _formQueriesRepo;

  FormComponentResponse? formResponse;

  final Map<String, ValueResponseForm?> saveSubmitData = {};
  Map<String, ValueResponseForm?> _capturedSaveSubmitData = {};

  List<Map<String, dynamic>> uploadedDocument = [];
  List<PatientDocument> patientDocuments = [];
  List<FormQueryDetails> formQueries = [];

  fetchForm(int formId, {bool isFromHomeScreen = false}) async {
    if (state is FormDetailProcessing) return;
    reset();
    emit(FormDetailProcessing(formId));

    var formData = await _patientTreatmentRepo.fetchFormDetail(formId);
    formData.when(success: (data) {
      formResponse = data;
      formResponse?.documentAttachment = _getDocumentAttachmentByFormId(formId);
      if (data.responses != null) {
        for (String key in data.responses!.keys) {
          var response = data.responses![key];
          if (response != null && response is Map<String, dynamic>) {
            try {
              saveSubmitData[key] = ValueResponseForm.fromJson(response);
            } catch (_) {}
          }
        }
        _capturedSaveSubmitData = Map.from(saveSubmitData);
      }

      if (isFromHomeScreen) {
        emit(FormDetailSuccessForHomeScreen(data));
      } else {
        emit(FormDetailSuccess(data));
      }
    }, error: (err) {
      emit(FormDetailError(err.message));
    });
  }

  addFormValue(String key, ValueResponseForm? value,
      {bool shouldNotifyChange = true}) {
    if (shouldNotifyChange) {
      emit(FormDetailInitial());
      saveSubmitData[key] = value;
      emit(FormDetailSelected(key, value?.value));
    } else {
      saveSubmitData[key] = value;
    }
  }

  addUnansweredReason(String key, String? reason) {
    saveSubmitData[key] = ValueResponseForm(
      displayValue: 'Unanswered: $reason',
      unansweredReason: reason,
    );
  }

  addChangeAnswerReason(String key, String? reason) {
    var dataReason = saveSubmitData[key];
    dataReason?.changeAnswerReason = reason;
    saveSubmitData[key] = dataReason;
  }

  fetchFormsByPatientTreatmentId(int patientTreatmentId) async {
    if (state is FormListFetching || state is FormDetailProcessing) return;
    emit(FormListFetching(patientTreatmentId));

    var formResult = await _patientTreatmentRepo
        .fetchFormsByPatientTreatmentId(patientTreatmentId);
    formResult.when(success: (data) async {
      data.listFormData.sort((a, b) => a.formOrder.compareTo(b.formOrder));
      if (data.patientId != null) {
        var documentsResult = await _patientDocumentRepo
            .fetchDocumentByPatientId(data.patientId!);
        documentsResult.when(success: (data) {
          patientDocuments = data;
        });
      }

      List<FormQueryDetails> queries = [];
      var queriesResult = await _formQueriesRepo.getQueriesByPatientTreatmentId(
        patientTreatmentId,
      );
      queriesResult.when(
        success: (data) {
          queries = data;
        },
      );

      emit(FormListFetched(data.listFormData, queries));
    }, error: (err) {
      emit(FormListError(err.message));
    });
  }

  saveForm({bool isShouldPopScreen = false}) async {
    if (!_validateEligibleQuestionPEF()) return;

    if (formResponse != null) {
      emit(const FormDetailSubmitDataProcessing());
      var result = await _patientTreatmentRepo.saveForm(
        formResponse!.id,
        saveSubmitData,
        _getEligibilityStatus(),
        uploadedDocument.isNotEmpty ? uploadedDocument : null,
      );
      result.when(success: (_) {
        _capturedSaveSubmitData = Map.from(saveSubmitData);
        emit(FormDetailSaveSuccess(isShouldPopScreen));
      }, error: (err) {
        emit(FormDetailError(err.message));
      });
    }
  }

  checkDataChangedAndSubmit() {
    bool isEligible =
        _validateEligibleQuestionPS() && _validateEligibleQuestionPEF();
    if (!isEligible) return;

    if (formResponse != null) {
      List<DataChangedForm> listUnanswered = [];
      List<DataChangedForm> listQueryModify = [];
      for (var component in formResponse!.form!.formElements!.components) {
        var unansweredQuestions = _getListQuestionUnanswered(
          component.components,
        );
        if (unansweredQuestions.isNotEmpty) {
          listUnanswered.add(DataChangedForm(
            component.title,
            unansweredQuestions,
          ));
        }
        var queryQuestions = _getListQuestionQueryModifyData(
          component.components,
        );
        if (queryQuestions.isNotEmpty) {
          listQueryModify.add(DataChangedForm(
            component.title,
            queryQuestions,
          ));
        }
      }

      if (listUnanswered.isNotEmpty) {
        emit(FormDetailRequireUnanswered(listUnanswered));
      } else if (listQueryModify.isNotEmpty) {
        emit(FormDetailRequireQueryModifyReason(listQueryModify));
      } else {
        submit();
      }
    }
  }

  List<ComponentDetail> _getListQuestionUnanswered(
      List<ComponentDetail> questions) {
    List<ComponentDetail> list = [];
    for (var question in questions) {
      if (question.input && question.validate.required) {
        bool isUnanswered = !saveSubmitData.containsKey(question.key) ||
            saveSubmitData[question.key]?.value.runtimeType == null ||
            saveSubmitData[question.key]?.value?.toString() == '';
        if (isUnanswered && isQuestionEnabled(question)) {
          list.add(question);
        }
      }
    }
    return list;
  }

  List<ComponentDetail> _getListQuestionQueryModifyData(
      List<ComponentDetail> questions) {
    List<ComponentDetail> list = [];
    Map filtered = _getElementHasChangeValue();
    for (var question in questions) {
      if (filtered.containsKey(question.key)) {
        for (FormQueryDetails query in formQueries) {
          if (question.key == query.questionKey) {
            bool isOpenQuery = query.status == FormQueryStatus.open.name;
            if (isQuestionEnabled(question) && isOpenQuery) {
              list.add(question);
            }
          }
        }
      }
    }
    return list;
  }

  Map _getElementHasChangeValue() {
    Map<String, ValueResponseForm?> filteredMap = {};
    for (var key in saveSubmitData.keys
        .toSet()
        .union(_capturedSaveSubmitData.keys.toSet())) {
      if (saveSubmitData[key] != _capturedSaveSubmitData[key]) {
        filteredMap[key] = saveSubmitData[key];
      }
    }
    return filteredMap;
  }

  bool _validateUnansweredForm() {
    List<ComponentDetail> questions = [];
    for (var component in formResponse!.form!.formElements!.components) {
      var unansweredQuestions =
          _getListQuestionUnanswered(component.components);
      for (var question in unansweredQuestions) {
        String? reason = saveSubmitData[question.key]?.unansweredReason;
        if (reason == null || reason.isEmpty) {
          questions.add(question);
        }
      }
    }
    if (questions.isNotEmpty) {
      emit(FormDetailDataChangedInvalid(questions));
    }
    return questions.isEmpty;
  }

  bool _validateDataChangeQueryForm() {
    List<ComponentDetail> questions = [];
    for (var component in formResponse!.form!.formElements!.components) {
      var changedAnswerQuestions =
          _getListQuestionQueryModifyData(component.components);
      for (var question in changedAnswerQuestions) {
        String? reason = saveSubmitData[question.key]?.changeAnswerReason;
        if (reason == null || reason.isEmpty) {
          questions.add(question);
        }
      }
    }
    if (questions.isNotEmpty) {
      emit(FormDetailDataChangedInvalid(questions));
    }
    return questions.isEmpty;
  }

  bool _validateEligibleQuestionPS() {
    if (FormType.ps.name != formResponse?.formTypeName) return true;

    List<ComponentDetail> questions = [];
    for (var component in formResponse!.form!.formElements!.components) {
      for (var question in component.components) {
        if (question.input &&
            question.validate.required &&
            question.eligibleValues != null &&
            question.eligibleValues!.isNotEmpty) {
          bool isUnanswered = !saveSubmitData.containsKey(question.key) ||
              saveSubmitData[question.key]?.value.runtimeType == null ||
              saveSubmitData[question.key]?.value?.toString() == '';
          if (isUnanswered && isQuestionEnabled(question)) {
            questions.add(question);
          }
        }
      }
    }
    if (questions.isNotEmpty) {
      emit(FormDetailValidateEligible(questions));
    }
    return questions.isEmpty;
  }

  bool _validateEligibleQuestionPEF() {
    if (FormType.pef.name != formResponse?.formTypeName) return true;
    List<ComponentDetail> unanswered = [];
    List<ComponentDetail> ineligible = [];

    for (var component in formResponse!.form!.formElements!.components) {
      for (var question in component.components) {
        if (question.input &&
            question.validate.required &&
            question.eligibleValues != null &&
            question.eligibleValues!.isNotEmpty) {
          if (isQuestionEnabled(question)) {
            bool isUnanswered = !saveSubmitData.containsKey(question.key) ||
                saveSubmitData[question.key]?.value.runtimeType == null ||
                saveSubmitData[question.key]?.value?.toString() == '';
            if (isUnanswered) {
              unanswered.add(question);
            } else {
              String selected =
                  [saveSubmitData[question.key]?.value].toString();
              if (question.eligibleValues.toString().compareTo(selected) != 0) {
                ineligible.add(question);
              }
            }
          }
        }
      }
    }

    if (unanswered.isNotEmpty) {
      emit(FormDetailValidateEligible(unanswered));
      return false;
    } else if (ineligible.isNotEmpty) {
      emit(const FormDetailPatientIneligible());
      emit(FormDetailInitial());
      return false;
    }
    return true;
  }

  submit() async {
    if (formResponse != null &&
        _validateUnansweredForm() &&
        _validateDataChangeQueryForm()) {
      emit(const FormDetailSubmitDataProcessing());
      var result = await _patientTreatmentRepo.submitForm(
        formResponse!.id,
        saveSubmitData,
        _getEligibilityStatus(),
        uploadedDocument.isNotEmpty ? uploadedDocument : null,
      );
      result.when(success: (_) async {
        saveSubmitData.clear();
        emit(const FormDetailSubmitSuccess());
      }, error: (err) {
        emit(FormDetailError(err.message));
      });
    }
  }

  bool isQuestionEnabled(ComponentDetail question) {
    String? conditionalKey = question.conditional!.when;
    if (question.conditional?.show == null) return true;
    if (!saveSubmitData.containsKey(conditionalKey)) return false;
    if (saveSubmitData[conditionalKey]?.value != question.conditional?.eq) {
      return false;
    }
    return question.conditional?.show ?? true;
  }

  int _getEligibilityStatus() {
    int status = 3;
    for (var element in formResponse!.form!.formElements!.components) {
      for (var com in element.components) {
        if (com.eligibleValues != null) {
          if (com.eligibleValues!.isNotEmpty) {
            if (saveSubmitData.containsKey(com.key)) {
              status = 1;
              String selected = [saveSubmitData[com.key]?.value].toString();
              if (com.eligibleValues.toString().compareTo(selected) != 0) {
                return status = 2;
              }
            }
          }
        }
      }
    }
    return status;
  }

  bool hasDataChange() {
    return !mapEquals(_capturedSaveSubmitData, saveSubmitData);
  }

  checkFormDeletion(FormComponentResponse form) async {
    bool isFormDeleting = form.deleting ?? false;
    bool isPatientDeleting = form.patientDeleting ?? false;
    if (isFormDeleting || isPatientDeleting) {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(FormDetailDeletion(isFormDeleting));
    }
  }

  List<PatientDocument> _getDocumentAttachmentByFormId(int formId) {
    List<PatientDocument> documents = [];
    if (patientDocuments.isNotEmpty) {
      for (var document in patientDocuments) {
        if (document.isDocumentOfForm(formId)) {
          documents.add(document);
        }
      }
    }
    return documents;
  }

  bool validateQueryQuestion() {
    List<ComponentDetail> questions = [];
    for (var component in formResponse!.form!.formElements!.components) {
      for (var question in component.components) {
        if (saveSubmitData.containsKey(question.key)) {
          for (FormQueryDetails query in formQueries) {
            if (question.key == query.questionKey) {
              if (isQuestionEnabled(question) &&
                  query.status == FormQueryStatus.open.name) {
                questions.add(question);
              }
            }
          }
        }
      }
    }
    return questions.isEmpty;
  }

  assignFormQueries(List<FormQueryDetails> queries) {
    formQueries
      ..clear()
      ..addAll(queries);
  }

  clearAllUnSubmitReason() {
    Map changedList = _getElementHasChangeValue();
    for (var key in changedList.keys) {
      saveSubmitData[key]?.unansweredReason = null;
      saveSubmitData[key]?.changeAnswerReason = null;
    }
  }

  reset() {
    formResponse = null;
    saveSubmitData.clear();
    uploadedDocument.clear();
    formQueries.clear();
  }
}

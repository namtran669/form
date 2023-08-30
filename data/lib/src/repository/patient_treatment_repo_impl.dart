import 'dart:io';

import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:data/src/data_source/remote/count_status_by_study_id_api.dart';
import 'package:data/src/data_source/remote/download_document_api.dart';
import 'package:data/src/data_source/remote/get_form_data_api.dart';
import 'package:data/src/data_source/remote/get_forms_by_patient_treatment_id_api.dart';
import 'package:data/src/data_source/remote/get_link_upload_file_api.dart';
import 'package:data/src/data_source/remote/get_list_files_uploaded_api.dart';
import 'package:data/src/data_source/remote/list_study_api.dart';
import 'package:data/src/data_source/remote/list_treatment_api.dart';
import 'package:data/src/data_source/remote/save_submit_form_api.dart';
import 'package:data/src/data_source/remote/upload_file_api.dart';
import 'package:data/src/models/app_user_data_model.dart';
import 'package:data/src/repository/base/base_repository.dart';
import 'package:dio/dio.dart' show MultipartFile;
import 'package:domain/domain.dart';
import 'package:domain/src/entities/form_query_details.dart';
import 'package:utils/utils.dart';

import '../data_source/remote/get_queries_summary_api.dart';
import '../models/form_query_details_model.dart';
import '../models/study_model.dart';
import '../models/treatment_paging_model.dart';

class PatientTreatmentRepoImpl extends BaseRepository
    implements PatientTreatmentRepo {
  PatientTreatmentRepoImpl(
      this._listStudyApi,
      this._listTreatmentApi,
      this._formDataApi,
      this._saveSubmitFormApi,
      this._getFormsByPatientIdApi,
      this._countStatusByStudyApi);

  final ListStudyApi _listStudyApi;
  final ListTreatmentApi _listTreatmentApi;
  final GetFormDataApi _formDataApi;
  final SaveSubmitFormApi _saveSubmitFormApi;
  final GetFormsByPatientTreatmentIdApi _getFormsByPatientIdApi;
  final CountStatusByStudyApi _countStatusByStudyApi;

  final AppUserData _userData = AppUserDataModel();

  @override
  Future<Result<List<Study>>> fetchStudies() async {
    final result = await safeApiCall<List<Study>>(
      _listStudyApi.get(_userData.accessToken!),
      mapper: (data) => StudyModel.fromList(data['data']),
    );
    return result;
  }

  @override
  Future<Result<TreatmentPaging>> fetchTreatments(
    int registryId,
    int page,
  ) async {
    final result = await safeApiCall<TreatmentPaging>(
      _listTreatmentApi.get(_userData.accessToken!, page, registryId),
      mapper: (json) => TreatmentPagingModel.fromJson(json['data']),
    );
    return result;
  }

  @override
  Future<Result<FormComponentResponse>> fetchFormDetail(int id) async {
    final result = await safeApiCall<FormComponentResponse>(
      _formDataApi.get(_userData.accessToken!, id),
      mapper: (json) => FormComponentResponse.fromJson(json['data']),
    );

    return result;
  }

  @override
  Future<Result<bool>> saveForm(
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  ) async {
    final result = await safeApiCall<bool>(
        _saveSubmitFormApi.save(
          _userData.accessToken!,
          id,
          formData,
          status,
          uploadedFiles,
        ),
        mapper: (json) => json != null);

    return result;
  }

  @override
  Future<Result<bool>> submitForm(
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  ) async {
    final result = await safeApiCall<bool>(
        _saveSubmitFormApi.submit(
          _userData.accessToken!,
          id,
          formData,
          status,
          uploadedFiles,
        ),
        mapper: (json) => json != null);

    return result;
  }

  @override
  Future<Result<FormsPatientData>> fetchFormsByPatientTreatmentId(
    int patientTreatmentId,
  ) async {
    int? patientId;
    List<FormData> listFormData = [];

    final formsResult = await safeApiCall(
      _getFormsByPatientIdApi.get(_userData.accessToken!, patientTreatmentId),
      mapper: (json) {
        Map<String, dynamic> itemsJson = json['data']['items'][0];
        listFormData = Utils.listFromJson(
          itemsJson['formData'],
          (item) {
            var formData = FormData.fromJson(item);
            formData.patientDeleting = itemsJson['patientDeleting'] as bool;
            return formData;
          },
        );
        patientId = itemsJson['patientId'];
        return listFormData;
      },
    );

    if (formsResult is Success) {
      return Success(FormsPatientData(listFormData, patientId));
    } else {
      return Error(
        ErrorType.GENERIC,
        'There is an error when fetching form data, please contact administrator',
      );
    }
  }

  @override
  Future<Result<TreatmentPaging>> fetchTreatmentsByStatuses(
    int registryId,
    int page,
    List<String> statuses,
  ) async {
    final result = await safeApiCall<TreatmentPaging>(
      _listTreatmentApi.get(
        _userData.accessToken!,
        page,
        registryId,
        statuses: statuses,
      ),
      mapper: (json) => TreatmentPagingModel.fromJson(json['data']),
    );
    return result;
  }

  @override
  Future<Result<Map<String, int>>> countFormByStatus(
    int registryId,
    List<String> statuses,
  ) async {
    Map<String, int> quantity = {};
    final statusResponse =
        await safeApiCallGetResponse(_countStatusByStudyApi.get(
      _userData.accessToken!,
      registryId,
      statuses,
    ));

    await statusResponse.when(success: (json) {
      List<dynamic> statusesJson = json.data['data']['status'];
      for (var statusJson in statusesJson) {
        quantity[statusJson['status']] = statusJson['total'];
      }
    });
    return Success(quantity);
  }
}

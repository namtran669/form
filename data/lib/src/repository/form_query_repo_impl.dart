import 'package:data/src/data_source/remote/get_assigned_queries_by_patient_treatment_id_api.dart';
import 'package:data/src/data_source/remote/get_assigned_queries_by_registry_id_api.dart';
import 'package:data/src/data_source/remote/get_comments_by_query_id_api.dart';
import 'package:data/src/data_source/remote/get_queries_summary_api.dart';
import 'package:data/src/models/app_user_data_model.dart';
import 'package:data/src/models/form_query_comments_model.dart';
import 'package:data/src/models/form_query_details_model.dart';
import 'package:data/src/repository/base/base_repository.dart';
import 'package:domain/domain.dart';

import '../data_source/remote/reply_comment_by_query_id_api.dart';

class FormQueriesRepoImpl extends BaseRepository implements FormQueriesRepo {
  FormQueriesRepoImpl(
    this._getQueriesSummaryApi,
    this._getCommentsByQueryIdApi,
    this._replyCommentByQueryIdApi,
    this._getAssignedQueriesByRegistryIdApi,
    this._getQueriesByPatientTreatmentIdApi,
  );

  final GetQueriesSummaryApi _getQueriesSummaryApi;
  final GetCommentsByQueryIdApi _getCommentsByQueryIdApi;
  final ReplyCommentByQueryIdApi _replyCommentByQueryIdApi;
  final GetAssignedQueriesByRegistryIdApi _getAssignedQueriesByRegistryIdApi;
  final GetQueriesByPatientTreatmentIdApi _getQueriesByPatientTreatmentIdApi;

  final AppUserData _userData = AppUserDataModel();

  @override
  Future<Result<List<FormQueryDetails>>> getQueriesByFormDataId(
      int formDataId) async {
    final result = await safeApiCall(
        _getQueriesSummaryApi.get(_userData.accessToken!, formDataId),
        mapper: (json) => FormQueryDetailsModel.fromList(json));
    return result;
  }

  @override
  Future<Result<List<FormQueryComments>>> getCommentsByQueryId(
      int queryId) async {
    return await safeApiCall(
        _getCommentsByQueryIdApi.get(_userData.accessToken!, queryId),
        mapper: (json) => FormQueryCommentsModel.fromList(json['queryLogs']));
  }

  @override
  Future<Result> replyComment(
    int queryId,
    String content,
    List<String> attachments,
  ) async {
    return await safeApiCallGetResponse(
      _replyCommentByQueryIdApi.comment(
        _userData.accessToken!,
        queryId,
        content,
        attachments,
      ),
    );
  }

  @override
  Future<Result<List<FormQueryDetails>>> getAssignedQueriesByRegistryId(
      int registryId) async {
    int count = 1000;
    String sort = 'updatedAt:desc';
    int start = 0;
    final result = await safeApiCall(
        _getAssignedQueriesByRegistryIdApi.get(
          _userData.accessToken!,
          count,
          registryId,
          sort,
          start,
        ),
        mapper: (json) => FormQueryDetailsModel.fromList(json['data']));
    return result;
  }

  @override
  Future<Result<List<FormQueryDetails>>> getQueriesByPatientTreatmentId(
      int patientTreatmentId) async {
    int count = 1000;
    String sort = 'updatedAt:desc';
    int start = 0;
    final result = await safeApiCall(
        _getQueriesByPatientTreatmentIdApi.get(
          _userData.accessToken!,
          count,
          patientTreatmentId,
          sort,
          start,
        ),
        mapper: (json) => FormQueryDetailsModel.fromList(json['data']));
    return result;
  }
}

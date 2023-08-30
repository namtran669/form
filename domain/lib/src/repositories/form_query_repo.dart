import '../../domain.dart';

abstract class FormQueriesRepo {
  Future<Result<List<FormQueryDetails>>> getQueriesByFormDataId(int formDataId);

  Future<Result<List<FormQueryComments>>> getCommentsByQueryId(int queryId);

  Future<Result> replyComment(
    int queryId,
    String content,
    List<String> attachments,
  );

  Future<Result<List<FormQueryDetails>>> getAssignedQueriesByRegistryId(
      int registryId);

  Future<Result<List<FormQueryDetails>>> getQueriesByPatientTreatmentId(
      int patientTreatmentId);
}

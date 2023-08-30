import '../../domain.dart';

abstract class PatientTreatmentRepo {
  Future<Result<List<Study>>> fetchStudies();

  Future<Result<TreatmentPaging>> fetchTreatments(int registryId, int page);

  Future<Result<TreatmentPaging>> fetchTreatmentsByStatuses(
    int registryId,
    int page,
    List<String> statuses,
  );

  Future<Result<FormComponentResponse>> fetchFormDetail(int id);

  Future<Result<bool>> saveForm(
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  );

  Future<Result<bool>> submitForm(
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  );

  Future<Result<FormsPatientData>> fetchFormsByPatientTreatmentId(int id);

  Future<Result<Map<String, int>>> countFormByStatus(
    int registryId,
    List<String> statuses,
  );
}

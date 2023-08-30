import 'package:domain/domain.dart';
import 'package:utils/utils.dart';

class FormDataModel extends FormData {
  FormDataModel({
    required int id,
    required int formId,
    required String formTypeName,
    required String statusName,
    required int formDataStatusId,
    required String startDate,
    required String endDate,
    required String formName,
    required int formOrder,
    required bool deleting,
    required int patientTreatmentId,
  }) : super(
          id,
          formId,
          formDataStatusId,
          formTypeName,
          statusName,
          startDate,
          endDate,
          formName,
          formOrder,
          deleting,
          patientTreatmentId,
        );

  factory FormDataModel.fromJson(Map<String, dynamic> json) {
    return FormDataModel(
      id: json['id'],
      formId: json['formId'] ?? 0,
      formTypeName: json['formTypeName'] ?? '-',
      formName: json['formName'] ?? '-',
      formDataStatusId: json['formDataStatusId'] ?? 0,
      statusName: json['statusName'] ?? '',
      startDate: json['startDate'] ?? '-',
      endDate: json['endDate'] ?? '-',
      formOrder: json['formOrder'] ?? -1,
      deleting: json['deleting'] ?? false,
      patientTreatmentId: json['patientTreatmentId'] ?? 0,
    );
  }

  static List<FormDataModel> fromList(List json) {
    return Utils.listFromJson(
      json,
      (item) => FormDataModel.fromJson(item),
    );
  }
}

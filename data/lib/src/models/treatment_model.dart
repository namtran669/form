import 'package:domain/src/entities/form_data_model.dart';
import 'package:domain/domain.dart';
import 'package:utils/utils.dart';

class TreatmentModel extends Treatment {
  TreatmentModel({
    required int id,
    required int treatmentId,
    required String? name,
    required String? date,
    required Patient? patient,
    required List<FormData> formData,
  }) : super(id, treatmentId, date, name, patient, formData);

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    String patientFirstName = json['patientFirstName'] ?? '';
    String patientLastName = json['patientLastName'] ?? '';
    int patientId = json['patientId'];
    String patientName = '$patientFirstName $patientLastName';
    return TreatmentModel(
      id: json['id'],
      treatmentId: json['treatmentId'] ?? 0,
      name: json['treatmentName'] ?? '-',
      date: json['treatmentDate'] ?? '-',
      patient: Patient(patientId, patientName),
      formData: FormDataModel.fromList(json['formData']),
    );
  }

  static List<TreatmentModel> fromList(List json) {
    return Utils.listFromJson(
      json,
      (item) => TreatmentModel.fromJson(item),
    );
  }
}

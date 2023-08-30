import 'package:domain/domain.dart';
import 'package:utils/utils.dart';

class PatientModel extends Patient {
  PatientModel({required int id, required String name}) : super(id, name);

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<PatientModel> fromList(List json) {
    return Utils.listFromJson(
      json, (item) => PatientModel.fromJson(item),
    );
  }
}
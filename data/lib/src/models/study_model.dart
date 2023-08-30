import 'package:domain/domain.dart';
import 'package:utils/utils.dart';

class StudyModel extends Study {
  StudyModel({required int id, required String name}) : super(id, name);

  factory StudyModel.fromJson(Map<String, dynamic> json) {
    return StudyModel(
      id: json['registryId'],
      name: json['name'],
    );
  }

  static List<StudyModel> fromList(List json) {
    return Utils.listFromJson(
      json, (item) => StudyModel.fromJson(item),
    );
  }
}
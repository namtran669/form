import 'package:domain/domain.dart';
import 'package:utils/utils.dart';

class FormQueryDetailsModel extends FormQueryDetails {
  FormQueryDetailsModel({
    required int id,
    required String status,
    required String createdByUser,
    required String assignee,
    required String description,
    required String lastUpdated,
    required String pageId,
    required String questionKey,
    required int assigneeId,
    required String originalResponse,
    required FormData? formData,
  }) : super(
          id,
          status,
          createdByUser,
          assignee,
          description,
          lastUpdated,
          pageId,
          questionKey,
          assigneeId,
          originalResponse,
          formData,
        );

  factory FormQueryDetailsModel.fromJson(Map<String, dynamic> json) {
    String createdByUser = '';
    Map<String, dynamic>? createdByUserJson = json['createdByUser'];
    if (createdByUserJson != null) {
      createdByUser =
          '${createdByUserJson['firstName']} ${createdByUserJson['lastName']}';
    }

    String assignee = '';
    int assigneeId = 0;
    Map<String, dynamic>? assigneeJson = json['assignee'];
    if (assigneeJson != null) {
      assignee = '${assigneeJson['firstName']} ${assigneeJson['lastName']}';
      assigneeId = assigneeJson['id'];
    }

    String originalResponse = '';
    Map<String, dynamic>? originalResponseJson = json['originalResponse'];
    if (originalResponseJson != null) {
      originalResponse = originalResponseJson['label'] ?? '';
    }

    FormData? formData;
    if (json.containsKey('formData') && json['formData'] != null) {
      try {
        formData = FormData.fromJson(json['formData']);
      } catch (_) {}
    }

    return FormQueryDetailsModel(
        id: json['id'] ?? 0,
        status: json['status'] ?? '',
        createdByUser: createdByUser,
        assignee: assignee,
        description: json['description'],
        lastUpdated: json['updatedAt'],
        pageId: json['pageId'] ?? '',
        questionKey: json['questionKey'] ?? '',
        assigneeId: assigneeId,
        originalResponse: originalResponse,
        formData: formData);
  }

  static List<FormQueryDetailsModel> fromList(List json) {
    return Utils.listFromJson(
      json,
      (item) => FormQueryDetailsModel.fromJson(item),
    );
  }
}

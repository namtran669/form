import 'package:domain/domain.dart';
import 'package:utils/utils.dart';

class FormQueryCommentsModel extends FormQueryComments {
  FormQueryCommentsModel({
    required int id,
    required String content,
    required String createdByUser,
    required String lastUpdated,
    required List<dynamic> attachments,
  }) : super(
          id,
          content,
          createdByUser,
          lastUpdated,
          attachments,
        );

  factory FormQueryCommentsModel.fromJson(Map<String, dynamic> json) {
    String createdByUser = '';
    Map<String, dynamic>? createdByUserJson = json['createdByUser'];
    if (createdByUserJson != null) {
      createdByUser =
          '${createdByUserJson['firstName']} ${createdByUserJson['lastName']}';
    }

    Map<String, dynamic> contentJson = json['content'];
    String contentComment = '';
    if(contentJson['content'] is String) {
      contentComment = contentJson['content'];
    } else if(contentJson['content'] is Map) {
      Map<String, dynamic>? assigneeJson = contentJson['content']['assignee'];
      contentComment = 'Assignee \n${assigneeJson?['oldValue']} -> ${assigneeJson?['newValue']}';
    }

    List<String> attachments = [];
    List<dynamic>? attachmentsJson = contentJson['attachments'];
    attachmentsJson?.forEach((json) {
      attachments.add(json['name']);
    });

    return FormQueryCommentsModel(
      id: json['id'] ?? 0,
      createdByUser: createdByUser,
      lastUpdated: json['updatedAt'],
      content: contentComment,
      attachments: attachments,
    );
  }

  static List<FormQueryCommentsModel> fromList(List json) {
    return Utils.listFromJson(
      json,
      (item) => FormQueryCommentsModel.fromJson(item),
    );
  }
}

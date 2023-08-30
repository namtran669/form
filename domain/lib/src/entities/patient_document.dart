import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PatientDocument {
  String fileName = '';
  String fileUrl = '';
  String fileKey = '';
  Map<int, List<dynamic>> formQuestionKeys = {};
  File? file;

  addQuestionKey(int formDataId, String key) {
    List<dynamic> keys = formQuestionKeys[formDataId] ?? [];
    keys.add(key);
    formQuestionKeys[formDataId] = keys;
  }

  bool isDocumentOfForm(int formId) {
    return formQuestionKeys.containsKey(formId);
  }

  @override
  String toString() {
    return 'Patient Document: {'
        'name: $fileName \n'
        'url: $fileUrl \n'
        'key: $fileKey \n'
        'questionKeys: $formQuestionKeys'
        '}';
  }
}

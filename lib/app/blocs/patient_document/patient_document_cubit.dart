import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'patient_document_state.dart';

class PatientDocumentCubit extends Cubit<PatientDocumentState> {
  PatientDocumentCubit(this._repo) : super(PatientDocumentInitial());

  final PatientDocumentRepo _repo;

  final Map<String, List<PatientDocument>> uploadingFiles = {};
  final List<Map<String, dynamic>> uploadedFiles = [];

  uploadFileByFormId(String formId, String questionKey, File file) async {
    emit(PatientDocumentUploading(questionKey));

    var result = await _repo.uploadImage(
      'form-data/$formId/${file.path.split('/').last}',
      'application/octet-stream',
      file,
    );

    result.when(success: (_) async {
      PatientDocument document = PatientDocument();
      String fileName = file.path.split('/').last;
      document.fileName = fileName;
      document.file = file;

      List<PatientDocument> existedFiles = uploadingFiles[questionKey] ?? [];
      existedFiles.add(document);

      uploadingFiles[questionKey] = existedFiles;
      uploadedFiles.add({
        'name': fileName,
        'key': 'form-data/$formId/$fileName',
        'size': await file.length(),
        'formDataUploadedFiles': [
          {
            'questionKeys': [questionKey],
            'formDataId': formId
          }
        ]
      });
      emit(PatientDocumentAddSuccess(uploadingFiles));
    }, error: (err) {
      emit(PatientDocumentError(questionKey, err.message));
    });
  }

  checkDocumentByFormId(int formId, List<PatientDocument> documents) async {
    if (documents.isNotEmpty) {
      for (var document in documents) {
        document.formQuestionKeys[formId]?.forEach((key) {
          List<PatientDocument> documents = uploadingFiles[key] ?? [];
          if (!documents.contains(document)) {
            documents.add(document);
            uploadingFiles[key] = documents;
          }
        });
      }

      if (uploadingFiles.isNotEmpty) {
        await Future.delayed(
          const Duration(seconds: 1),
          () => emit(PatientDocumentAddSuccess(uploadingFiles)),
        );
      }
    }
  }

  reset() {
    uploadingFiles.clear();
    uploadedFiles.clear();
  }
}

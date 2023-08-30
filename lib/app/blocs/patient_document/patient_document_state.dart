part of 'patient_document_cubit.dart';

abstract class PatientDocumentState extends Equatable {
  const PatientDocumentState();
}

class PatientDocumentInitial extends PatientDocumentState {
  @override
  List<Object> get props => [];
}

class PatientDocumentUploading extends PatientDocumentState {
  final String questionKey;

  const PatientDocumentUploading(this.questionKey);

  @override
  List<Object?> get props => [questionKey];
}

class PatientDocumentAddSuccess extends PatientDocumentState {
  final Map<String, dynamic> uploadingDocument;

  const PatientDocumentAddSuccess(this.uploadingDocument);

  @override
  List<Object?> get props => [uploadingDocument];
}

class PatientDocumentError extends PatientDocumentState {
  final String questionKey;
  final String errorMsg;

  const PatientDocumentError(this.questionKey, this.errorMsg);

  @override
  List<Object?> get props => [questionKey, errorMsg];
}

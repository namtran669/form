import 'dart:io';

import '../../domain.dart';

abstract class PatientDocumentRepo {
  Future<Result<Map<String, dynamic>>> uploadImage(String key, String contentType, File file);

  Future<Result<List<PatientDocument>>> fetchDocumentByPatientId(int patientId);

  Future<Result<List<dynamic>>> downloadUrl(List<String> params);
}
import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class GetFormsByPatientTreatmentIdApi {
  Future<Response> get(String token, int patientId);
}

class GetFormsByPatientTreatmentIdApiImpl
    implements GetFormsByPatientTreatmentIdApi {
  final EdcApiClient _client;

  GetFormsByPatientTreatmentIdApiImpl(this._client);

  @override
  Future<Response> get(String token, int patientId) async {
    return _client.get(
      '${ApiEndpoint.PATIENT_DATA}',
      headers: {'authorization': token},
      params: {'patientTreatmentId' : patientId}
    );
  }
}
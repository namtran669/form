import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class GetQueriesByPatientTreatmentIdApi {
  Future<Response> get(
    String token,
    int count,
    int registryId,
    String sort,
    int start,
  );
}

class GetQueriesByPatientTreatmentIdApiImpl
    implements GetQueriesByPatientTreatmentIdApi {
  final EdcApiClient _client;

  GetQueriesByPatientTreatmentIdApiImpl(this._client);

  @override
  Future<Response> get(
    String token,
    int count,
    int patientTreatmentId,
    String sort,
    int start,
  ) async {
    return await _client.get(
      ApiEndpoint.QUERIES,
      headers: {'authorization': token},
      params: {
        'count': count,
        'patientTreatmentId': patientTreatmentId,
        'sort': sort,
        'start': start
      },
    );
  }
}

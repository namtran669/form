import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class ListTreatmentApi {
  Future<Response> get(String token, int page, int registryIds,
      {List<String>? statuses});
}

class ListTreatmentApiImpl implements ListTreatmentApi {
  final EdcApiClient _client;

  ListTreatmentApiImpl(this._client);

  @override
  Future<Response> get(String token, int page, int registryIds,
      {List<String>? statuses}) async {
    Map<String, dynamic> params = {};
    params['page'] = page;
    params['registryIds'] = registryIds;
    if(statuses != null) {
      params['statuses'] = statuses;
    }
    return await _client.get(ApiEndpoint.PATIENT_DATA,
        headers: {'authorization': token},
        params: params);
  }
}

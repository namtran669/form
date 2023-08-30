import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class GetQueriesSummaryApi {
  Future<Response> get(String token, int formDataId);
}

class GetQueriesSummaryApiImpl implements GetQueriesSummaryApi {
  final EdcApiClient _client;

  GetQueriesSummaryApiImpl(this._client);

  @override
  Future<Response> get(String token, int formDataId) async {
    return await _client.get(
      ApiEndpoint.QUERIES_SUMMARY,
      headers: {'authorization': token},
      params: {'formDataIds': formDataId},
    );
  }
}

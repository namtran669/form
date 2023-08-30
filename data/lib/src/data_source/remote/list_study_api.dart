import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class ListStudyApi {
  Future<Response> get(String token);
}

class ListStudyApiImpl implements ListStudyApi {
  final EdcApiClient _client;

  ListStudyApiImpl(this._client);

  @override
  Future<Response> get(String token) async {
    return await _client.get(ApiEndpoint.LIST_STUDY,
        headers: {'authorization': token});
  }
}
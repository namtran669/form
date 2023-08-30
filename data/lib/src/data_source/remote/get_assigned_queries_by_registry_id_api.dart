import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class GetAssignedQueriesByRegistryIdApi {
  Future<Response> get(
    String token,
    int count,
    int registryId,
    String sort,
    int start,
  );
}

class GetAssignedQueriesByRegistryIdApiImpl
    implements GetAssignedQueriesByRegistryIdApi {
  final EdcApiClient _client;

  GetAssignedQueriesByRegistryIdApiImpl(this._client);

  @override
  Future<Response> get(
    String token,
    int count,
    int registryId,
    String sort,
    int start,
  ) async {
    return await _client.get(
      ApiEndpoint.QUERIES,
      headers: {'authorization': token},
      params: {
        'count': count,
        'registry': registryId,
        'sort': sort,
        'start': start
      },
    );
  }
}

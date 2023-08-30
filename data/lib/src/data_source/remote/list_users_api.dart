import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class ListUsersApi {
  Future<Response> get(String token);
}

class ListUsersApiImpl implements ListUsersApi {
  final EdcApiClient _client;

  ListUsersApiImpl(this._client);

  @override
  Future<Response> get(String token) async {
    return await _client.get(
      ApiEndpoint.USERS_LIST_USERS,
      headers: {'authorization': token},
    );
  }
}

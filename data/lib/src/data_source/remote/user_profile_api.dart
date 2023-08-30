import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class UserProfileApi {
  Future<Response> get(String token);
}

class UserProfileApiImpl implements UserProfileApi {
  final EdcApiClient _client;

  UserProfileApiImpl(this._client);

  @override
  Future<Response> get(String token) async {
    return _client.get(
      ApiEndpoint.USER_PROFILE,
      headers: {'authorization': token},
    );
  }
}

import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class UserUpdateFcmTokenApi {
  Future<Response> update(String authorization, String token, String platform);
}

class UserUpdateFcmTokenApiImpl implements UserUpdateFcmTokenApi {
  final EdcApiClient _client;

  UserUpdateFcmTokenApiImpl(this._client);

  @override
  Future<Response> update(String authorization, String token, String platform) async {
    return _client.post(
      ApiEndpoint.USERS_FCM_TOKEN,
      headers: {'authorization': authorization},
      data: {
        'deviceToken': token,
        'platform': platform
      }
    );
  }
}

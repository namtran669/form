import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class ChangePasswordApi {
  Future<Response> request(String token, String oldPassword, String newPassword);
}

class ChangePasswordApiImpl implements ChangePasswordApi {
  final EdcApiClient client;

  ChangePasswordApiImpl(this.client);

  @override
  Future<Response> request(String token, String oldPassword, String newPassword) {
    return client.post(
      ApiEndpoint.CHANGE_PASSWORD,
      headers: {'authorization': token},
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword
      },
    );
  }
}

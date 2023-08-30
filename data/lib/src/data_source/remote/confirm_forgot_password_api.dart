import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class ConfirmForgotPasswordApi {
  Future<Response> request(String email, String password, String code);
}

class ConfirmForgotPasswordApiImpl implements ConfirmForgotPasswordApi {
  final EdcApiClient client;

  ConfirmForgotPasswordApiImpl(this.client);

  @override
  Future<Response> request(String email, String password, String code) {
    return client.post(
      ApiEndpoint.CONFIRM_FORGOT_PASSWORD,
      data: {
        'email': email,
        'password': password,
        'confirmPassword': password,
        'confirmationCode': code
      },
    );
  }
}

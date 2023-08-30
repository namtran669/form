import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class ForgotPasswordApi {
  Future<Response> request(String email);
}

class ForgotPasswordApiImpl implements ForgotPasswordApi {
  final EdcApiClient client;

  ForgotPasswordApiImpl(this.client);

  @override
  Future<Response> request(String email) {
    return client.post(
        ApiEndpoint.FORGOT_PASSWORD,
        data: {'email':email},
    );
  }
}
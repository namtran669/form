import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';


abstract class MfaVerifyOtpApi {
  Future<Response> verify(String token, int sessionId, String otp);
}

class MfaVerifyOtpApiImpl implements MfaVerifyOtpApi {
  final EdcApiClient client;

  MfaVerifyOtpApiImpl(this.client);

  @override
  Future<Response> verify(String token, int sessionId, String otp) {
    return client.post(
      ApiEndpoint.VERIFY_CHALLENGE_OTP,
      data: {'code':otp, 'sessionId': sessionId},
      headers: {'authorization': token}
    );
  }
}
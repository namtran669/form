import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class OtpAuthResendApi {
  Future<Response> request(
    String email,
    String sessionId,
    String internalToken,
  );
}

class OtpAuthResendApiImpl implements OtpAuthResendApi {
  final EdcApiClient _client;

  OtpAuthResendApiImpl(this._client);

  @override
  Future<Response> request(
    String email,
    String sessionId,
    String internalToken,
  ) {
    return _client.post(
      ApiEndpoint.OTP_AUTH_RESEND,
      data: {'userEmail': email, 'sessionId': sessionId},
      headers: {'authorization-internal': internalToken},
    );
  }
}

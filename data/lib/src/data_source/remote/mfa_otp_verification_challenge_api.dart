import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class MfaOtpVerificationChallengeApi {
  Future<Response> request(String token, String phone);
}

class MfaOtpVerificationChallengeApiImpl implements MfaOtpVerificationChallengeApi {
  final EdcApiClient _client;

  MfaOtpVerificationChallengeApiImpl(this._client);

  @override
  Future<Response> request(String token, String phone) {
    return _client.post(
      ApiEndpoint.OTP_VERIFICATION_CHALLENGE,
      data: {'otpOption': 'sms', 'phoneNumber': phone},
      headers: {'authorization': token},
    );
  }
}

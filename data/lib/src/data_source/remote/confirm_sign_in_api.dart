import 'dart:convert';

import 'package:data/src/data_source/remote/base/api_client.dart';
import 'package:dio/dio.dart';

abstract class ConfirmSignInApi {
  Future<Response> confirm(
    String? username,
    String otp,
    String? clientId,
    String? sessionId,
    String? internalAccessToken,
    String? loginSession,
  );
}

class ConfirmSignInApiImpl implements ConfirmSignInApi {
  final AwsApiClient client;

  ConfirmSignInApiImpl(this.client);

  @override
  Future<Response> confirm(
    String? username,
    String otp,
    String? clientId,
    String? sessionId,
    String? internalAccessToken,
    String? loginSession,
  ) {
    Map<String, String> _headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.RespondToAuthChallenge'
    };

    Map<String, dynamic> _data = {
      'ChallengeResponses': {
        'USERNAME': username,
        'ANSWER': '{\"code\": \"$otp\"}'
      },
      'ChallengeName': 'CUSTOM_CHALLENGE',
      'ClientId': clientId,
      'ClientMetadata': {
        'session_id': sessionId,
        'access_token': internalAccessToken,
      },
      'Session': loginSession,
    };

    return client.post(
      '',
      headers: _headers,
      data: jsonEncode(_data),
    );
  }
}

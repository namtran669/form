import 'dart:convert';

import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class SignInApi {
  Future<Response> signIn(
    String? username,
    String? clientId,
    String? sessionId,
    String? internalAccessToken,
  );
}

class SignInApiImpl implements SignInApi {
  final AwsApiClient client;

  SignInApiImpl(this.client);

  @override
  Future<Response> signIn(
    String? username,
    String? clientId,
    String? sessionId,
    String? internalAccessToken,
  ) {
    Map<String, dynamic> _data = {
      'AuthParameters': {'USERNAME': username},
      'AuthFlow': 'CUSTOM_AUTH',
      'ClientId': clientId,
      'ClientMetadata': {
        'session_id': sessionId,
        'access_token': internalAccessToken
      }
    };

    Map<String, String> _headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.InitiateAuth'
    };

    return client.post(
      '',
      headers: _headers,
      data: jsonEncode(_data),
    );
  }
}

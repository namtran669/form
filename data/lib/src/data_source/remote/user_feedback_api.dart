import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class UserFeedbackApi {
  Future<Response> post(String token, String feedback);
}

class UserFeedbackApiImpl implements UserFeedbackApi {
  final EdcApiClient _client;

  UserFeedbackApiImpl(this._client);

  @override
  Future<Response> post(
    String token,
    String feedback,
  ) {
    return _client.post(
      ApiEndpoint.USER_FEEDBACK,
      data: {
        'howToImprove': feedback,
        'platformSatisfaction': 'Satisfied',
        'serviceSatisfaction': 'Satisfied',
        'recommendValue': 8,
        'willingToDiscuss': 'Yes'
      },
      headers: {'authorization': token},
    );
  }
}

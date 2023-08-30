import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class GetCommentsByQueryIdApi {
  Future<Response> get(String token, int queryId);
}

class GetCommentsByQueryIdApiImpl implements GetCommentsByQueryIdApi {
  final EdcApiClient _client;

  GetCommentsByQueryIdApiImpl(this._client);

  @override
  Future<Response> get(String token, int queryId) async {
    return _client.get(
      '${ApiEndpoint.QUERIES}/$queryId',
      headers: {'authorization': token},
    );
  }
}
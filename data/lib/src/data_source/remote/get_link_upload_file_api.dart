import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class GetLinkUploadFileApi {
  Future<Response> post(
    String token,
    String key,
    String contentType,
  );
}

class GetLinkUploadFileApiImpl implements GetLinkUploadFileApi {
  final EdcApiClient _client;

  GetLinkUploadFileApiImpl(this._client);

  @override
  Future<Response> post(
    String token,
    String key,
    String contentType,
  ) async {
    Map<String, dynamic> params = {};
    params['acl'] = 'private';
    params['key'] = key;
    params['contentType'] = contentType;

    return await _client.post(
      '${ApiEndpoint.FORMS_UPLOAD_URL}',
      headers: {'authorization': token},
      data: {
        'params': [params]
      },
    );
  }
}

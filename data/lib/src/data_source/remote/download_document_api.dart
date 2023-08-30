import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class DownloadDocumentApi {
  Future<Response> download(String token, List<String> params);
}

class DownloadDocumentApiImpl implements DownloadDocumentApi {
  final EdcApiClient _client;

  DownloadDocumentApiImpl(this._client);

  @override
  Future<Response> download(String token, List<String> keys) {
    List params = [];
    for(String key in keys) {
        params.add({'key': key});
    }

    return _client.post(
      ApiEndpoint.FORMS_DOWNLOAD_URL,
      headers: {'authorization': token},
      data: {
        'params': params
      },
    );
  }
}

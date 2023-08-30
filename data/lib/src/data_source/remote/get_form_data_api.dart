import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class GetFormDataApi {
  Future<Response> get(String token, int id);
}

class FormDataApiImpl implements GetFormDataApi {
  final EdcApiClient _client;

  FormDataApiImpl(this._client);

  @override
  Future<Response> get(String token, int id) async {
    return await _client.get('${ApiEndpoint.FORM_DATA}/$id',
        headers: {'authorization': token});
  }
}

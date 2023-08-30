import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class SaveSubmitFormApi {
  Future<Response> save(
    String token,
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  );

  Future<Response> submit(
    String token,
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  );
}

class SaveSubmitFormApiImpl implements SaveSubmitFormApi {
  final EdcApiClient _client;

  SaveSubmitFormApiImpl(this._client);

  @override
  Future<Response> save(
    String token,
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  ) async {
    Map<String, dynamic> body = {};
    body['isSubmit'] = false;
    body['dataComponent'] = formData;
    body['eligibilityStatus'] = status;
    if (uploadedFiles != null) {
      body['uploadedFiles'] = uploadedFiles;
    }
    return await _client.put(
      '${ApiEndpoint.FORM_DATA}/$id/fill-component',
      headers: {'authorization': token},
      data: body,
    );
  }

  @override
  Future<Response> submit(
    String token,
    int id,
    Map<String, dynamic> formData,
    int status,
    List<Map<String, dynamic>>? uploadedFiles,
  ) async {
    Map<String, dynamic> body = {};
    body['isSubmit'] = true;
    body['dataComponent'] = formData;
    body['eligibilityStatus'] = status;
    if (uploadedFiles != null) {
      body['uploadedFiles'] = uploadedFiles;
    }
    return await _client.put(
      '${ApiEndpoint.FORM_DATA}/$id/fill-component',
      headers: {'authorization': token},
      data: body,
    );
  }
}

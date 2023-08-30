import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class GetListFilesUploadedApi {
  Future<Response> get(
    String token,
    String patientId,
  );
}

class GetListFilesUploadedApiImpl implements GetListFilesUploadedApi {
  final EdcApiClient _client;

  GetListFilesUploadedApiImpl(this._client);

  @override
  Future<Response> get(
    String token,
      String patientId,
  ) async {
    return await _client.get(
      '${ApiEndpoint.PATIENT}/$patientId/uploaded-files',
      headers: {'authorization': token},
    );
  }
}

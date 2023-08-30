import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';

import 'base/api_client.dart';

abstract class CountStatusByStudyApi {
  Future<Response> get(String token, int id, List<String> statuses);
}

class CountStatusByStudyApiImpl implements CountStatusByStudyApi {
  final EdcApiClient _client;

  CountStatusByStudyApiImpl(this._client);

  @override
  Future<Response> get(
      String token, int registryId, List<String> statuses) async {
    String statusesParam = '';
    statuses.forEach((status) {
      statusesParam += '$status,';
    });
    return await _client.get(
      '${ApiEndpoint.COUNT_FORM_STATUS}',
      headers: {'authorization': token},
      params: {'registryIds': registryId, 'formStatuses': statusesParam.substring(0, statusesParam.length -1)},
    );
  }
}

import 'package:data/src/data_source/remote/base/api_endpoint.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

import 'base/api_client.dart';

abstract class MfaSettingApi {
  Future<bool> setting(String token, MfaSettingBody body);
}

class MfaSettingApiImpl implements MfaSettingApi {
  final EdcApiClient _client;

  MfaSettingApiImpl(this._client);

  @override
  Future<bool> setting(String token, MfaSettingBody body) async {
    Response response = await _client.put(
      ApiEndpoint.MFA_SETTING,
      data: body.toJson(),
      headers: {'authorization': token},
    );
    return response.statusCode == 200;
  }
}

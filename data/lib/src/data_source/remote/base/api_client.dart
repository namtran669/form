import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../models/app_user_data_model.dart';
import '../../local/shared_preferences_store.dart';
import 'api_endpoint.dart';

const int kApiConnectTimeout = 30000;

class ApiClient {
  final Dio _dio;
  final SharedPrefsStore _storage;

  ApiClient(this._dio, this._storage) {
    _dio.options.connectTimeout = kApiConnectTimeout;
    _dio.options.receiveTimeout = kApiConnectTimeout;
    _dio.options.sendTimeout = kApiConnectTimeout;
    _dio.options.contentType = Headers.jsonContentType;
    _dio.options.responseType = ResponseType.json;

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ));
    } else {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            return handler.next(request);
          },
          onResponse: (response, handle) {
            return handle.next(response);
          },
          onError: (err, handler) async {
            if (err.response != null) {
              if (err.response!.statusCode == ApiStatusCode.ACCESS_TOKEN_EXPIRE) {
                AuthSession res = await Amplify.Auth.fetchAuthSession(
                    options: CognitoSessionOptions(getAWSCredentials: true));
                CognitoAuthSession session = res as CognitoAuthSession;

                String? accessToken = session.userPoolTokens?.accessToken;
                String? refreshToken = res.userPoolTokens?.refreshToken;
                var userData = AppUserDataModel();
                userData.accessToken = accessToken;
                userData.refreshToken = refreshToken;
                _storage.saveUserData(userData);

                err.requestOptions.headers['authorization'] = accessToken;
                final newOptions = Options(
                    method: err.requestOptions.method,
                    headers: err.requestOptions.headers);

                final newRequest = await _dio.request(
                  err.requestOptions.path,
                  data: err.requestOptions.data,
                  options: newOptions,
                  queryParameters: err.requestOptions.queryParameters,
                  cancelToken: err.requestOptions.cancelToken,
                );
                return handler.resolve(newRequest);
              }
            }
            return handler.next(err);
          },
        ),
      );
    }
  }

  Future<Response<T>> get<T>(
    String uri, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<T>(
      uri,
      options: Options(headers: headers),
      queryParameters: params,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String uri, {
    data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post(
      uri,
      data: data,
      options: Options(headers: headers),
      queryParameters: params,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String uri, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    return await _dio.delete(
      uri,
      options: Options(headers: headers),
      queryParameters: params,
    );
  }

  Future<Response<T>> put<T>(
    String uri, {
    data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    return await _dio.put(
      uri,
      data: data,
      options: Options(headers: headers),
      queryParameters: params,
    );
  }
}

class EdcApiClient extends ApiClient {
  EdcApiClient(Dio dio, SharedPrefsStore storage) : super(dio, storage);
}

class AwsApiClient extends ApiClient {
  AwsApiClient(Dio dio, SharedPrefsStore storage) : super(dio, storage);
}

class AwsChimeApiClient extends ApiClient {
  AwsChimeApiClient(Dio dio, SharedPrefsStore storage) : super(dio, storage);

}
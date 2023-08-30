import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

typedef ResponseToModel<Model> = Model Function(dynamic);

abstract class BaseRepository {
  Future<Result<Model>> safeApiCall<Model>(
    Future<Response> call, {
    required ResponseToModel<Model> mapper,
  }) async {
    try {
      var response = await call;
      return Success<Model>(mapper.call(response.data));
    } on Exception catch (exception) {
      if (exception is DioError) {
        switch (exception.type) {
          case DioErrorType.connectTimeout:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.cancel:
            return Error(
              ErrorType.POOR_NETWORK,
              'Your internet connection is poor, please check your internet connection.',
            );

          case DioErrorType.other:
            return Error(
              ErrorType.NO_NETWORK,
              'No network, please check your internet connection.',
            );

          case DioErrorType.response:
            return ServerError(
              type: ErrorType.SERVER,
              error: exception.response?.data['message'] ?? exception.message,
              code: exception.response!.statusCode!,
            );
        }
      }
      return Error(
        ErrorType.GENERIC,
        'There is an internal error, please try again.',
      );
    }
  }

  Future<Result<Response>> safeApiCallGetResponse<Object>(
      Future<Response> call) async {
    try {
      var response = await call;
      return Success(response);
    } on Exception catch (exception) {
      if (exception is DioError) {
        switch (exception.type) {
          case DioErrorType.connectTimeout:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.cancel:
            return Error(
              ErrorType.POOR_NETWORK,
              'Your internet connection is poor, please check your internet connection.',
            );

          case DioErrorType.other:
            return Error(
              ErrorType.NO_NETWORK,
              'No network, please check your internet connection.',
            );

          case DioErrorType.response:
            return ServerError(
              type: ErrorType.SERVER,
              error: exception.response?.data['message'] ?? exception.message,
              code: exception.response!.statusCode!,
            );
        }
      }
      return Error(
        ErrorType.GENERIC,
        'There is an internal error, please try again.',
      );
    }
  }
}

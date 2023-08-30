import 'package:dio/dio.dart';


abstract class UploadFileApi {
  Future<Response> upload(String link, Map<String, dynamic> data);
}

class UploadFileApiImpl implements UploadFileApi {

  @override
  Future<Response> upload(String link, Map<String, dynamic> data) async {
    int timeout = 30000;
    String contentType = 'multipart/form-data';
    Dio dio = Dio(BaseOptions(
      baseUrl: link,
      contentType: contentType,
      sendTimeout: timeout,
      receiveTimeout: timeout,
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseHeader: false,
      responseBody: true,
    ));

    FormData formData = FormData.fromMap(data);
    return await dio.post(link,
        options: Options(headers: {'Content-Type': 'multipart/form-data; boundary=<calculated when request is sent>'}),
        data: formData);
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

import '../data_source/remote/base/api_endpoint.dart';
import '../data_source/remote/download_document_api.dart';
import '../data_source/remote/get_link_upload_file_api.dart';
import '../data_source/remote/get_list_files_uploaded_api.dart';
import '../data_source/remote/upload_file_api.dart';
import '../models/app_user_data_model.dart';
import 'base/base_repository.dart';

class PatientDocumentRepoImpl extends BaseRepository
    implements PatientDocumentRepo {
  PatientDocumentRepoImpl(
    this._getLinkUploadFileApi,
    this._uploadFileApi,
    this._getListFilesUploadedApi,
    this._downloadDocumentApi,
  );

  final GetLinkUploadFileApi _getLinkUploadFileApi;
  final UploadFileApi _uploadFileApi;
  final GetListFilesUploadedApi _getListFilesUploadedApi;
  final DownloadDocumentApi _downloadDocumentApi;

  final AppUserData _userData = AppUserDataModel();

  @override
  Future<Result<List<PatientDocument>>> fetchDocumentByPatientId(
    int patientId,
  ) async {
    List<PatientDocument> patientDocuments = [];
    var fileUploadedJson = await safeApiCall<List<dynamic>>(
      _getListFilesUploadedApi.get(
        _userData.accessToken!,
        patientId.toString(),
      ),
      mapper: (json) => json,
    );

    List<String> fileKeys = [];
    await fileUploadedJson.when(
      success: (data) async {
        if (data.isNotEmpty) {
          for (var fileJson in data) {
            var document = PatientDocument();
            String fileName = fileJson['name'];
            document.fileName = fileName;

            String key = fileJson['key'];
            document.fileKey = key;
            fileKeys.add(key);

            List<dynamic> uploadFiles = fileJson['formDataUploadedFiles'];
            if (uploadFiles.isNotEmpty) {
              for (var uploadFile in uploadFiles) {
                int formDataId = uploadFile['formDataId'];
                List<dynamic> keys = uploadFile['questionKeys'];
                document.formQuestionKeys[formDataId] = keys;
              }
            }
            patientDocuments.add(document);
          }

          if (fileKeys.isNotEmpty) {
            var patientDocumentJson = await downloadUrl(fileKeys);
            await patientDocumentJson.when(
              success: (urlJsonList) {
                if (urlJsonList.isNotEmpty) {
                  for (var urlJson in urlJsonList) {
                    String url = urlJson['url'];
                    for (int i = 0; i < patientDocuments.length; i++) {
                      var document = patientDocuments[i];
                      if (document.fileUrl.isEmpty &&
                          url.contains(document.fileName)) {
                        document.fileUrl = url;
                        patientDocuments[i] = document;
                        break;
                      }
                    }
                  }
                }
              },
            );
          }
        }
      },
    );
    return Success(patientDocuments);
  }

  @override
  Future<Result<Map<String, dynamic>>> uploadImage(
    String key,
    String contentType,
    File file,
  ) async {
    Map<String, dynamic>? uploadDataField;
    bool isUploadSuccess = false;
    final linkUploadResponse = await safeApiCallGetResponse(
      _getLinkUploadFileApi.post(
        _userData.accessToken!,
        key,
        contentType,
      ),
    );

    await linkUploadResponse.when(success: (response) async {
      Map<String, dynamic> linkUploadJson = response.data['data'][0];
      String url = linkUploadJson['url'];
      uploadDataField = linkUploadJson['fields'];
      String fileName = file.path.split('/').last;
      uploadDataField!['file'] = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      );
      var uploadResult = await _uploadFileApi.upload(url, uploadDataField!);
      isUploadSuccess = ApiStatusCode.NO_CONTENT == uploadResult.statusCode &&
          uploadDataField != null;
    }, error: (err) {
      return Error(ErrorType.GENERIC, err.message);
    });

    if (isUploadSuccess) {
      return Success(uploadDataField!);
    } else {
      return Error(
        ErrorType.GENERIC,
        'Error when upload image, please contact admin.',
      );
    }
  }

  @override
  Future<Result<List>> downloadUrl(List<String> fileKeys) async {
    return await safeApiCall<List<dynamic>>(
        _downloadDocumentApi.download(
          _userData.accessToken!,
          fileKeys,
        ),
        mapper: (json) => json['data']);
  }
}

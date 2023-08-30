import 'package:dio/dio.dart';

import 'base/api_client.dart';
import 'base/api_endpoint.dart';

abstract class ReplyCommentByQueryIdApi {
  Future<Response> comment(
    String token,
    int queryId,
    String content,
    List<String> attachments,
  );
}

class ReplyCommentByQueryIdApiImpl implements ReplyCommentByQueryIdApi {
  final EdcApiClient _client;

  ReplyCommentByQueryIdApiImpl(this._client);

  @override
  Future<Response> comment(
    String token,
    int queryId,
    String content,
    List<String> attachments,
  ) async {
    List<Map<String, String>> attachmentsMap = [
      for (var attachment in attachments)
        {
          'key': 'query/$queryId/$attachment',
          'name': attachment,
        }
    ];

    return _client.post(
      '${ApiEndpoint.QUERIES}/$queryId/comment',
      headers: {'authorization': token},
      data: {'attachments': attachmentsMap, 'content': content},
    );
  }
}

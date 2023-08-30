import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

import '../../ui_model/form_query_status.dart';

part 'form_queries_state.dart';

class FormQueriesCubit extends Cubit<FormQueriesState> {
  FormQueriesCubit(
    this._formQueryRepo,
    this._patientDocumentRepo,
  ) : super(FormQueriesInitial());

  final FormQueriesRepo _formQueryRepo;
  final PatientDocumentRepo _patientDocumentRepo;

  final List<File> _attachments = [];
  final List<FormQueryDetails> _queriesFormData = [];
  final List<FormQueryDetails> _queriesRegistry = [];
  int _currentQueryId = 0;
  int _currentFormDataId = 0;
  int _currentRegistryId = 0;
  var _currentFilter = FormQueryFilter.all;

  fetchQueriesByFormDataId(int formDataId) async {
    if (formDataId != _currentFormDataId) {
      _currentFormDataId = formDataId;
      var result = await _formQueryRepo.getQueriesByFormDataId(formDataId);
      result.when(
          success: (data) {
            _queriesFormData
              ..clear()
              ..addAll(data);
            emit(FormQueriesLoaded(_queriesFormData));
          },
          error: (error) => emit(FormQueriesError(error.message)));
    }
  }

  refreshQueriesStatus() {
    fetchQueriesByFormDataId(_currentFormDataId);
  }

  fetchCommentsByQueriesId(int queryId) async {
    _currentQueryId = queryId;
    if (state is FormQueriesCommentsLoading) return;
    emit(FormQueriesCommentsLoading());
    var result = await _formQueryRepo.getCommentsByQueryId(queryId);
    result.when(
        success: (comments) => emit(FormQueriesCommentsLoaded(comments)),
        error: (error) => emit(FormQueriesError(error.message)));
  }

  uploadDocumentForQueryId(File file) async {
    emit(FormQueriesAttachmentLoading());
    String fileName = file.path.split('/').last;
    var result = await _patientDocumentRepo.uploadImage(
      'query/$_currentQueryId/$fileName',
      'image/${fileName.split('.').last}',
      file,
    );
    result.when(
        success: (_) {
          _attachments.add(file);
          emit(FormQueriesAttachmentSuccess(_attachments));
        },
        error: (e) => emit(FormQueriesError(e.message)));
  }

  deleteDocument(int index) {
    if (state is FormQueriesAttachmentSuccess) {
      emit(FormQueriesInitial());
    }
    _attachments.removeAt(index);
    emit(FormQueriesAttachmentSuccess(_attachments));
  }

  replyComment(String comment) async {
    if (comment.isEmpty && _attachments.isEmpty) return;
    if (state is FormQueriesAttachmentLoading) return;
    emit(FormQueriesCommentSending());
    List<String> attachments = [];
    for (var attachment in _attachments) {
      attachments.add(attachment.path.split('/').last);
    }
    var result = await _formQueryRepo.replyComment(
      _currentQueryId,
      comment,
      attachments,
    );

    result.when(
      success: (_) async {
        emit(FormQueriesCommentSuccess());
        _attachments.clear();
        await Future.delayed(const Duration(seconds: 1));
        await fetchCommentsByQueriesId(_currentQueryId);
      },
      error: (e) => FormQueriesError(e.message),
    );
  }

  downloadDocument(String fileName) async {
    emit(FormQueriesDocumentDownloading(fileName));
    String key = 'query/$_currentQueryId/$fileName';
    var result = await _patientDocumentRepo.downloadUrl([key]);
    result.when(
        success: (urlJsonList) {
          if (urlJsonList.isNotEmpty) {
            String url = urlJsonList[0]['url'];
            emit(FormQueriesDownloadDocumentSuccess(url, fileName));
          } else {
            emit(FormQueriesDownloadDocumentError('Can not open this file.'));
          }
        },
        error: (e) => emit(FormQueriesDownloadDocumentError(e.message)));
  }

  fetchAssignedQueriesByRegistryId(int registryId) async {
    _currentRegistryId = registryId;
    emit(FormQueriesAssignedLoading());
    var result =
        await _formQueryRepo.getAssignedQueriesByRegistryId(registryId);
    result.when(
        success: (data) {
          _queriesRegistry
            ..clear()
            ..addAll(data);
          emit(FormQueriesAssignedLoaded(_queriesRegistry));
        },
        error: (e) => emit(FormQueriesAssignedError(e.message)));
  }

  refreshAssignedQueriesByRegistryId() async {
    await fetchAssignedQueriesByRegistryId(_currentRegistryId);
    filterAssignedQueriesByStatus(_currentFilter);
  }

  filterAssignedQueriesByStatus(FormQueryFilter filter) {
    _currentFilter = filter;
    if (filter == FormQueryFilter.all) {
      emit(FormQueriesAssignedLoaded(_queriesRegistry));
      return;
    }

    List<FormQueryDetails> queriesFiltered = _queriesRegistry
        .where((query) => query.status.toLowerCase() == filter.name.toLowerCase())
        .toList();
    emit(FormQueriesAssignedLoaded(queriesFiltered));
  }

  emitNewQueries(List<FormQueryDetails> list) {
    emit(FormQueriesExisted(list));
  }
}

part of 'form_queries_cubit.dart';

abstract class FormQueriesState extends Equatable {}

class FormQueriesInitial extends FormQueriesState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FormQueriesLoading extends FormQueriesState {
  @override
  List<Object?> get props => [FormQueriesLoading];
}

class FormQueriesLoaded extends FormQueriesState {
  final List<FormQueryDetails> queries;

  FormQueriesLoaded(this.queries);

  @override
  List<Object?> get props => [queries];
}

class FormQueriesError extends FormQueriesState {
  final String message;

  FormQueriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class FormQueriesCommentsLoading extends FormQueriesState {
  @override
  List<Object?> get props => [FormQueriesCommentsLoading];
}

class FormQueriesCommentsLoaded extends FormQueriesState {
  final List<FormQueryComments> comments;

  FormQueriesCommentsLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class FormQueriesAttachmentSuccess extends FormQueriesState {
  final List attachments;

  FormQueriesAttachmentSuccess(this.attachments);

  @override
  List<Object?> get props => [attachments];
}

class FormQueriesAttachmentLoading extends FormQueriesState {
  FormQueriesAttachmentLoading();

  @override
  List<Object?> get props => [FormQueriesAttachmentLoading];
}

class FormQueriesCommentSending extends FormQueriesState {
  @override
  List<Object?> get props => [FormQueriesCommentSending];
}

class FormQueriesCommentSuccess extends FormQueriesState {
  @override
  List<Object?> get props => [FormQueriesCommentSending];
}

class FormQueriesDocumentDownloading extends FormQueriesState {
  final String fileName;

  FormQueriesDocumentDownloading(this.fileName);

  @override
  List<Object?> get props => [];
}

class FormQueriesDownloadDocumentSuccess extends FormQueriesState {
  final String url;
  final String fileName;

  FormQueriesDownloadDocumentSuccess(this.url, this.fileName);

  @override
  List<Object?> get props => [url];
}

class FormQueriesDownloadDocumentError extends FormQueriesState {
  final String message;

  FormQueriesDownloadDocumentError(this.message);

  @override
  List<Object?> get props => [message];
}

class FormQueriesAssignedLoading extends FormQueriesState {
  @override
  List<Object?> get props => [FormQueriesAssignedLoading];
}

class FormQueriesAssignedLoaded extends FormQueriesState {
  final List<FormQueryDetails> queries;

  FormQueriesAssignedLoaded(this.queries);

  @override
  List<Object?> get props => [queries];
}

class FormQueriesAssignedError extends FormQueriesState {
  final String message;

  FormQueriesAssignedError(this.message);

  @override
  List<Object?> get props => [message];
}

class FormQueriesExisted extends FormQueriesState {
  final List<FormQueryDetails> queries;

  FormQueriesExisted(this.queries);

  @override
  List<Object?> get props => [queries];
}
part of 'form_detail_cubit.dart';

abstract class FormDetailState extends Equatable {
  const FormDetailState();
}

class FormDetailInitial extends FormDetailState {
  @override
  List<Object> get props => [];
}

class FormDetailProcessing extends FormDetailState {
  final int id;

  const FormDetailProcessing(this.id);

  @override
  List<Object?> get props => [id];
}

class FormDetailSuccess extends FormDetailState {
  final FormComponentResponse component;

  const FormDetailSuccess(this.component);

  @override
  List<Object?> get props => [component];
}

class FormDetailSuccessForHomeScreen extends FormDetailState {
  final FormComponentResponse component;

  const FormDetailSuccessForHomeScreen(this.component);

  @override
  List<Object?> get props => [component];
}

class FormDetailError extends FormDetailState {
  final String msg;

  const FormDetailError(this.msg);

  @override
  List<Object?> get props => [msg];
}

class FormDetailSelected extends FormDetailState {
  final String key;
  final dynamic value;

  const FormDetailSelected(this.key, this.value);

  @override
  List<Object?> get props => [key, value];

  @override
  bool? get stringify => true;
}

class FormDetailSaveSuccess extends FormDetailState {
  final bool isShouldPop;

  const FormDetailSaveSuccess(this.isShouldPop);

  @override
  List<Object?> get props => [isShouldPop];
}

class FormDetailSubmitSuccess extends FormDetailState {
  const FormDetailSubmitSuccess();

  @override
  List<Object?> get props => [FormDetailSubmitSuccess];
}

class FormDetailSubmitDataProcessing extends FormDetailState {
  const FormDetailSubmitDataProcessing();

  @override
  List<Object?> get props => [FormDetailSubmitDataProcessing];
}

class FormDetailRequireUnanswered extends FormDetailState {
  final List<DataChangedForm> unanswered;

  const FormDetailRequireUnanswered(this.unanswered);

  @override
  List<Object?> get props => unanswered;
}

class FormDetailRequireQueryModifyReason extends FormDetailState {
  final List<DataChangedForm> modifyList;

  const FormDetailRequireQueryModifyReason(this.modifyList);

  @override
  List<Object?> get props => modifyList;
}

class FormDetailDataChangedInvalid extends FormDetailState {
  final List<ComponentDetail> questions;

  const FormDetailDataChangedInvalid(this.questions);

  @override
  List<Object?> get props => questions;
}

class FormListFetching extends FormDetailState {
  final int id;

  const FormListFetching(this.id);

  @override
  List<Object?> get props => [FormListFetching];
}

class FormListFetched extends FormDetailState {
  final List<FormData> forms;
  final List<FormQueryDetails> queries;

  const FormListFetched(this.forms, this.queries);

  @override
  List<Object?> get props => [forms];
}

class FormListError extends FormDetailState {
  final String msg;

  const FormListError(this.msg);

  @override
  List<Object?> get props => [msg];
}

class FormDetailValidateEligible extends FormDetailState {
  final List<ComponentDetail> questions;

  const FormDetailValidateEligible(this.questions);

  @override
  List<Object?> get props => questions;
}

class FormDetailPatientIneligible extends FormDetailState {
  const FormDetailPatientIneligible();

  @override
  List<Object?> get props => [];
}

class FormDetailDeletion extends FormDetailState {
  final bool shouldShowMessage;

  const FormDetailDeletion(this.shouldShowMessage);

  @override
  List<Object?> get props => [];
}

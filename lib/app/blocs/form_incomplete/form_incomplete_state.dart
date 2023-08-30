part of 'form_incomplete_bloc.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class FormIncompleteFetching extends HomeState {
  @override
  List<Object?> get props => [];
}

class FormIncompleteFetched extends HomeState {

  final List<FormData> forms;

  FormIncompleteFetched(this.forms);

  @override
  List<Object> get props => [forms];
}

class FormIncompleteFetchFail extends HomeState {
  final String error;

  FormIncompleteFetchFail(this.error);

  @override
  List<Object?> get props => [];
}

part of 'form_incomplete_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FormIncompleteRequested extends HomeEvent {

  const FormIncompleteRequested();

  @override
  List<Object> get props => [];
}

class HomeUpdateStudy extends HomeEvent {
  final Study study;

  const HomeUpdateStudy(this.study);

  @override
  List<Object> get props => [study];
}
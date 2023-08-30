part of 'study_cubit.dart';

abstract class StudyState extends Equatable {}

class StudyInitial extends StudyState {
  @override
  List<Object> get props => [];
}

class StudyLoading extends StudyState {
  @override
  List<Object> get props => [StudyLoading];
}

class StudySelected extends StudyState {
  final Study study;

  StudySelected(this.study);

  @override
  List<Object> get props => [study];
}
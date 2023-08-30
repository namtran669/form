part of 'form_counter_cubit.dart';

@immutable
abstract class FormCounterState extends Equatable{}

class FormCounterInitial extends FormCounterState {
  @override
  List<Object?> get props => [];
}

class FormStatusCounted extends FormCounterState {
  final int completed, incomplete;

  FormStatusCounted(this.completed, this.incomplete);

  @override
  List<Object?> get props => [completed, incomplete];
}

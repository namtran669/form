part of 'treatment_bloc.dart';

abstract class PatientTreatmentEvent extends Equatable {}

class TreatmentFetched extends PatientTreatmentEvent {

  TreatmentFetched();

  @override
  List<Object> get props => [];
}

class PatientUpdateStudy extends PatientTreatmentEvent {
  final Study study;

  PatientUpdateStudy(this.study);

  @override
  List<Object> get props => [study];
}

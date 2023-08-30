part of 'treatment_bloc.dart';

enum LoadMoreStatus { initial, success, failure }

class PatientTreatmentState extends Equatable {
  const PatientTreatmentState({
    this.status = LoadMoreStatus.initial,
    this.treatments = const <Treatment>[],
    this.hasReachedMax = false,
  });

  final LoadMoreStatus status;
  final List<Treatment> treatments;
  final bool hasReachedMax;

  PatientTreatmentState copyWith({
    LoadMoreStatus? status,
    int? patientTreatmentId,
    List<Treatment>? treatments,
    bool? hasReachedMax,
  }) {
    return PatientTreatmentState(
      status: status ?? this.status,
      treatments: treatments ?? this.treatments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''TreatmentState { status: $status, hasReachedMax: $hasReachedMax, treatments: ${treatments.length} }''';
  }

  @override
  List<Object> get props => [status, treatments, hasReachedMax];
}

class TreatmentSendData extends Equatable {
  final Treatment treatment;
  final int patientTreatmentId;

  const TreatmentSendData(this.patientTreatmentId, this.treatment);

  @override
  List<Object?> get props => [treatment, patientTreatmentId];
}
import 'package:equatable/equatable.dart';

import '../../domain.dart';

class Treatment extends Equatable {
  final int id;
  final int treatmentId;
  final String? date;
  final String? name;
  final Patient? patient;
  final List<FormData> formData;

  Treatment(
    this.id,
    this.treatmentId,
    this.date,
    this.name,
    this.patient,
    this.formData,
  );

  @override
  List<Object?> get props => [id, treatmentId, name, date, patient];

}

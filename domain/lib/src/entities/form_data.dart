import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form_data.g.dart';

@JsonSerializable()
class FormData extends Equatable {
  final int id;
  final int formId;
  final int formDataStatusId;
  final String formTypeName;
  final String statusName;
  final String formName;
  final String startDate;
  final String endDate;
  final int formOrder;
  final bool? deleting;
  final int patientTreatmentId;
  late bool? patientDeleting;

  FormData(
    this.id,
    this.formId,
    this.formDataStatusId,
    this.formTypeName,
    this.statusName,
    this.startDate,
    this.endDate,
    this.formName,
    this.formOrder,
    this.deleting,
    this.patientTreatmentId,
  );

  @override
  List<Object?> get props => [
        id,
        formId,
        formTypeName,
        formName,
        startDate,
        endDate,
        deleting,
        patientDeleting,
      ];

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);
}

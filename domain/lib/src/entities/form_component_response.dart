import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain.dart';
import 'form_component.dart';

part 'form_component_response.g.dart';

@JsonSerializable()
class FormComponentResponse {
  final int id;
  final String statusName;
  final int lockStatus;
  final String startDate;
  final String endDate;
  final Map<String, dynamic>? responses;
  final FormDetails? form;
  bool? patientDeleting;
  bool? deleting;
  String? formTypeName;
  List<PatientDocument>? documentAttachment;

  FormComponentResponse(
      this.id,
      this.formTypeName,
      this.statusName,
      this.lockStatus,
      this.deleting,
      this.startDate,
      this.endDate,
      this.responses,
      this.form);

  factory FormComponentResponse.fromJson(Map<String, dynamic> json) =>
      _$FormComponentResponseFromJson(json);
}

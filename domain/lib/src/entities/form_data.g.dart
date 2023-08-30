// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormData _$FormDataFromJson(Map<String, dynamic> json) => FormData(
      json['id'] as int,
      json['formId'] as int,
      json['formDataStatusId'] as int? ?? 0,
      json['formTypeName'] as String? ?? '',
      json['statusName'] as String? ?? '',
      json['startDate'] as String? ?? '',
      json['endDate'] as String? ?? '',
      json['formName'] as String? ?? '',
      json['formOrder'] ?? 0,
      json['deleting'] as bool?,
      json['patientTreatmentId'] as int? ?? 0
    )..patientDeleting = json['patientDeleting'] as bool?;

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
      'id': instance.id,
      'formId': instance.formId,
      'formDataStatusId': instance.formDataStatusId,
      'formTypeName': instance.formTypeName,
      'statusName': instance.statusName,
      'formName': instance.formName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'formOrder': instance.formOrder,
      'deleting': instance.deleting,
      'patientDeleting': instance.patientDeleting,
    };

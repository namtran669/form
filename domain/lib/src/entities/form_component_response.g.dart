// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_component_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormComponentResponse _$FormComponentResponseFromJson(
        Map<String, dynamic> json) =>
    FormComponentResponse(
      json['id'] as int,
      json['formTypeName'] as String?,
      json['statusName'] as String,
      json['lockStatus'] as int,
      json['deleting'] as bool?,
      json['startDate'] as String,
      json['endDate'] as String,
      json['responses'] as Map<String, dynamic>?,
      json['form'] == null
          ? null
          : FormDetails.fromJson(json['form'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormComponentResponseToJson(
        FormComponentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statusName': instance.statusName,
      'lockStatus': instance.lockStatus,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'responses': instance.responses,
      'form': instance.form,
      'patientDeleting': instance.patientDeleting,
      'deleting': instance.deleting,
      'formTypeName': instance.formTypeName,
      'documentAttachment': instance.documentAttachment,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormResponse _$FormResponseFromJson(Map<String, dynamic> json) => FormResponse(
      json['key'] as String,
      ValueResponseForm.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormResponseToJson(FormResponse instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

ValueResponseForm _$ValueResponseFormFromJson(Map<String, dynamic> json) =>
    ValueResponseForm(
      value: json['value'],
      displayValue: json['displayValue'],
      unansweredReason: json['unansweredReason'] as String?,
    );

Map<String, dynamic> _$ValueResponseFormToJson(ValueResponseForm instance) =>
    <String, dynamic>{
      'value': instance.value,
      'displayValue': instance.displayValue,
      'unansweredReason': instance.unansweredReason,
    };

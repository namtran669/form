// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormDetails _$FormDetailsFromJson(Map<String, dynamic> json) => FormDetails(
      json['id'] as int?,
      json['uuid'] as String?,
      json['name'] as String,
      json['formElements'] == null
          ? null
          : FormElements.fromJson(json['formElements'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormDetailsToJson(FormDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
      'formElements': instance.formElements,
    };

FormElements _$FormElementsFromJson(Map<String, dynamic> json) => FormElements(
      (json['components'] as List<dynamic>)
          .map((e) => FormComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FormElementsToJson(FormElements instance) =>
    <String, dynamic>{
      'components': instance.components,
    };

FormComponent _$FormComponentFromJson(Map<String, dynamic> json) =>
    FormComponent(
      json['id'] as String?,
      json['key'] as String?,
      json['title'] as String,
      (json['components'] as List<dynamic>)
          .map((e) => ComponentDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['label'] as String,
      json['name'] as String?,
      json['input'] as bool,
    );

Map<String, dynamic> _$FormComponentToJson(FormComponent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'label': instance.label,
      'input': instance.input,
      'title': instance.title,
      'name': instance.name,
      'components': instance.components,
    };

ComponentDetail _$ComponentDetailFromJson(Map<String, dynamic> json) =>
    ComponentDetail(
      json['id'] as String,
      json['key'] as String,
      json['type'] as String,
      json['input'] as bool,
      json['label'] as String,
      json['conditional'] == null
          ? null
          : Conditional.fromJson(json['conditional'] as Map<String, dynamic>),
      (json['values'] as List<dynamic>?)
          ?.map((e) => ValuesDataForm.fromJson(e))
          .toList(),
      json['content'] as String?,
      FormValidate.fromJson(json['validate']),
      json['format'] as String?,
      json['placeholder'] as String?,
      json['suffix'] as String?,
      json['disabled'] as bool?,
      json['data'] == null ? null : DataForm.fromJson(json['data']),
      json['eligibleValues'] as List<dynamic>?,
    );

Map<String, dynamic> _$ComponentDetailToJson(ComponentDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'type': instance.type,
      'input': instance.input,
      'label': instance.label,
      'content': instance.content,
      'format': instance.format,
      'placeholder': instance.placeholder,
      'suffix': instance.suffix,
      'conditional': instance.conditional,
      'values': instance.values,
      'eligibleValues': instance.eligibleValues,
      'validate': instance.validate,
      'disabled': instance.disabled,
      'data': instance.data,
    };

Conditional _$ConditionalFromJson(Map<String, dynamic> json) => Conditional(
      json['eq'] as String?,
      json['json'] as String?,
      json['show'],
      json['when'] as String?,
    );

Map<String, dynamic> _$ConditionalToJson(Conditional instance) =>
    <String, dynamic>{
      'eq': instance.eq,
      'json': instance.json,
      'show': instance.show,
      'when': instance.when,
    };

ValuesDataForm _$ValuesDataFormFromJson(Map<String, dynamic> json) =>
    ValuesDataForm(
      json['label'],
      json['value'],
      json['shortcut'] as String?,
      json['fullLabel'] as String?,
    );

Map<String, dynamic> _$ValuesDataFormToJson(ValuesDataForm instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'shortcut': instance.shortcut,
      'fullLabel': instance.fullLabel,
    };

FormValidate _$FormValidateFromJson(Map<String, dynamic> json) => FormValidate(
      json['required'] as bool,
      json['custom'] as String,
    );

Map<String, dynamic> _$FormValidateToJson(FormValidate instance) =>
    <String, dynamic>{
      'custom': instance.custom,
      'required': instance.required,
    };

DataForm _$DataFormFromJson(Map<String, dynamic> json) => DataForm(
      json['url'] as String?,
      json['json'] as String?,
      json['custom'] as String?,
      (json['values'] as List<dynamic>?)
          ?.map((e) => ValuesDataForm.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$DataFormToJson(DataForm instance) => <String, dynamic>{
      'url': instance.url,
      'json': instance.json,
      'custom': instance.custom,
      'values': instance.values,
    };

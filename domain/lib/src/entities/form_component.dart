import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:utils/utils.dart';

part 'form_component.g.dart';

@JsonSerializable()
class FormDetails extends Equatable {
  final int? id;
  final String? uuid;
  final String name;
  final FormElements? formElements;

  const FormDetails(
    this.id,
    this.uuid,
    this.name,
    this.formElements,
  );

  factory FormDetails.fromJson(Map<String, dynamic> json) =>
      _$FormDetailsFromJson(json);

  @override
  List<Object?> get props => [
        id,
        uuid,
        name,
        formElements,
      ];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class FormElements extends Equatable {
  final List<FormComponent> components;

  const FormElements(this.components);

  factory FormElements.fromJson(Map<String, dynamic> json) =>
      _$FormElementsFromJson(json);

  @override
  List<Object?> get props => [components];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class FormComponent extends Equatable {
  final String? id;
  final String? key;
  final String label;
  final bool input;
  final String title;
  final String? name;
  final List<ComponentDetail> components;

  const FormComponent(
    this.id,
    this.key,
    this.title,
    this.components,
    this.label,
    this.name,
    this.input,
  );

  factory FormComponent.fromJson(Map<String, dynamic> json) =>
      _$FormComponentFromJson(json);

  @override
  List<Object?> get props => [
        id,
        key,
        label,
        title,
        components,
      ];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class ComponentDetail extends Equatable {
  final String id;
  final String key;
  final String type;
  final bool input;
  final String label;
  final String? content;
  final String? format;
  final String? placeholder;
  final String? suffix;
  final Conditional? conditional;
  final List<ValuesDataForm>? values;
  final List<dynamic>? eligibleValues;
  final FormValidate validate;
  final bool? disabled;
  final DataForm? data;

  const ComponentDetail(
    this.id,
    this.key,
    this.type,
    this.input,
    this.label,
    this.conditional,
    this.values,
    this.content,
    this.validate,
    this.format,
    this.placeholder,
    this.suffix,
    this.disabled,
    this.data,
    this.eligibleValues,
  );

  factory ComponentDetail.fromJson(Map<String, dynamic> json) =>
      _$ComponentDetailFromJson(json);

  @override
  List<Object?> get props => [
        id,
        key,
        type,
        label,
        suffix,
        conditional,
        values,
        data,
      ];

  @override
  String toString() {
    return 'id: $id - label: $label';
  }
}

@JsonSerializable()
class Conditional extends Equatable {
  final String? eq;
  final String? json;
  final dynamic show;
  final String? when;

  const Conditional(this.eq, this.json, this.show, this.when);

  factory Conditional.fromJson(Map<String, dynamic> json) =>
      _$ConditionalFromJson(json);

  @override
  List<Object?> get props => [eq, json, show, when];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class ValuesDataForm implements Equatable {
  final dynamic label;
  final dynamic value;
  final String? shortcut;
  final String? fullLabel;

  ValuesDataForm(
    this.label,
    this.value,
    this.shortcut,
    this.fullLabel,
  );

  @override
  List<Object?> get props => [
        label,
        value,
        shortcut,
        fullLabel,
      ];

  @override
  bool? get stringify => true;

  factory ValuesDataForm.fromJson(json) => _$ValuesDataFormFromJson(json);

  Map<String, dynamic> toJson() => _$ValuesDataFormToJson(this);

  static List<ValuesDataForm> fromList(List json) {
    return Utils.listFromJson(
      json,
      (item) => ValuesDataForm.fromJson(item),
    );
  }

  @override
  String toString() {
    return 'value: $value - label: $label';
  }
}

@JsonSerializable()
class FormValidate implements Equatable {
  final String custom;
  final bool required;

  const FormValidate(this.required, this.custom);

  @override
  List<Object?> get props => [required];

  @override
  bool? get stringify => true;

  factory FormValidate.fromJson(json) => _$FormValidateFromJson(json);
}

@JsonSerializable()
class DataForm implements Equatable {
  final String? url;
  final String? json;
  final String? custom;
  final List<ValuesDataForm>? values;

  DataForm(
    this.url,
    this.json,
    this.custom,
    this.values,
  );

  @override
  List<Object?> get props => [url, json, custom, values];

  @override
  bool? get stringify => true;

  factory DataForm.fromJson(json) => _$DataFormFromJson(json);

  Map<String, dynamic> toJson() => _$DataFormToJson(this);
}

class DataChangedForm implements Equatable {
  final String title;
  final List<ComponentDetail> questions;

  DataChangedForm(this.title, this.questions);

  @override
  List<Object?> get props => [title, questions];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    return 'Label: $title - Question: $questions';
  }
}

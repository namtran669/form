import 'package:json_annotation/json_annotation.dart';

part 'form_response.g.dart';

@JsonSerializable()
class FormResponse {
  final String key;
  final ValueResponseForm value;

  FormResponse(this.key, this.value);

  @override
  String toString() => 'key: $key: valueData: $value';

  factory FormResponse.fromJson(Map<String, dynamic> json) =>
      _$FormResponseFromJson(json);
}

@JsonSerializable()
class ValueResponseForm {
  final dynamic value;
  final dynamic displayValue;
  String? unansweredReason;
  String? changeAnswerReason;

  ValueResponseForm({
    this.value,
    this.displayValue,
    this.unansweredReason,
    this.changeAnswerReason,
  });

  factory ValueResponseForm.fromJson(Map<String, dynamic> json) =>
      _$ValueResponseFormFromJson(json);

  @override
  String toString() => 'value: $value, displayValue: $displayValue,'
      ' unansweredReason: $unansweredReason ,'
      ' changeAnswerReason: $changeAnswerReason';

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'displayValue': displayValue,
      'unansweredReason': unansweredReason,
      'changeAnswerReason': changeAnswerReason,
    };
  }

  @override
  int get hashCode => 1010;

  @override
  bool operator ==(other) {
    return (other is ValueResponseForm) &&
        other.value == value &&
        other.displayValue == displayValue &&
        other.unansweredReason == unansweredReason &&
        other.changeAnswerReason == changeAnswerReason;
  }
}

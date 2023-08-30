import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class RadioViewModel implements Equatable {
  final String questionKey;
  final List<ValuesDataForm>? values;

  RadioViewModel(this.values, this.questionKey);

  @override
  List<Object?> get props => [questionKey, values];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class DateTimeViewModel implements Equatable {
  final String questionKey;
  final String format;
  final String placeholder;

  DateTimeViewModel({
    required this.questionKey,
    required this.format,
    required this.placeholder,
  });

  @override
  List<Object?> get props => [questionKey, format, placeholder];

  @override
  bool? get stringify => true;
}

class TextFieldViewModel implements Equatable {
  final String? id;
  final String questionKey;
  final String? suffix;
  final String? type;

  TextFieldViewModel({
    required this.id,
    required this.questionKey,
    required this.suffix,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        questionKey,
        suffix,
        type,
      ];

  @override
  bool? get stringify => true;
}

class SelectBoxViewModel implements Equatable {
  final String questionKey;
  final List<ValuesDataForm> values;

  SelectBoxViewModel({
    required this.questionKey,
    required this.values,
  });

  @override
  List<Object?> get props => [
        values,
      ];

  @override
  bool? get stringify => true;
}

class DropDownViewModel implements Equatable {
  final String questionKey;
  final DataForm data;

  DropDownViewModel({
    required this.questionKey,
    required this.data,
  });

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  bool? get stringify => true;
}

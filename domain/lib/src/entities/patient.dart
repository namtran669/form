import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient extends Equatable {
  final int id;
  final String name;

  Patient(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}
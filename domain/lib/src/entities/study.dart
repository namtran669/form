import 'package:equatable/equatable.dart';

class Study extends Equatable {
  final int registryId;
  final String name;

  Study(this.registryId, this.name);

  @override
  List<Object?> get props => [registryId, name];
}
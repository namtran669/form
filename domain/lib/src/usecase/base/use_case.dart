import 'package:equatable/equatable.dart';

import '../../common/result.dart';

abstract class UseCase {
  call();
}

abstract class UseCaseResult<Type, Params> extends UseCase {
  @override
  Future<Result<Type>> call({Params param});
}

abstract class UseCaseNoResult<Params> extends UseCase {
  @override
  call({Params param});
}

abstract class UseCaseResultLocal<Type, Params> extends UseCase {
  @override
  Result<Type> call({Params param});
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

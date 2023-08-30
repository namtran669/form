import 'package:domain/domain.dart';

class ConfirmAccount extends UseCaseResult<bool, String> {
  final AuthenticationRepo _repo;

  ConfirmAccount(this._repo);

  @override
  Future<Result<bool>> call({String? param}) async {
    return await _repo.confirmAccount(param!);
  }
}

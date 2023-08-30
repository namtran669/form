import '../../domain.dart';

class ConfirmSignIn extends UseCaseResult<bool, String>  {
  final AuthenticationRepo _repo;
  ConfirmSignIn(this._repo);

  @override
  Future<Result<bool>> call({String? param}) {
    return _repo.confirmSignIn(param!);
  }
}

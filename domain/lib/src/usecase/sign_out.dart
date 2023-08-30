import '../../domain.dart';

class SignOut extends UseCaseResult<void, NoParams>  {
  final AuthenticationRepo _repo;
  SignOut(this._repo);

  @override
  Future<Result> call({NoParams? param}) async {
    return await _repo.signOut();
  }
}
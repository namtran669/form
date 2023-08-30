

import '../../domain.dart';

class SignIn extends UseCaseResult<AppUserData, LoginRequest>  {
  final AuthenticationRepo _repo;
  SignIn(this._repo);

  @override
  Future<Result<AppUserData>> call({LoginRequest? param}) async {
    return await _repo.signIn(param!.username, param.password);
  }
}



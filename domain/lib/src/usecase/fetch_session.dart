

import '../../domain.dart';

class FetchSession extends UseCaseResult<AppUserData, NoParams>  {
  final AuthenticationRepo _repo;
  FetchSession(this._repo);

  @override
  Future<Result<AppUserData>> call({NoParams? param}) async {
    return await _repo.fetchSession();
  }
}



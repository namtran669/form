import 'package:domain/domain.dart';

class FetchUserProfile extends UseCaseResult<AppUserData, NoParams>  {
  final UserDataRepo _repo;
  FetchUserProfile(this._repo);

  @override
  Future<Result<AppUserData>> call({NoParams? param}) async {
    return await _repo.fetchUserProfile();
  }
}



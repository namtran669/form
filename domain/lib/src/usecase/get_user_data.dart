import 'package:domain/domain.dart';

class GetUserData implements UseCaseResult<AppUserData, NoParams> {
  final UserDataRepo _repo;

  const GetUserData(this._repo);

  @override
  Future<Result<AppUserData>> call({NoParams? param}) async {
    var data = await _repo.userData;
    if(data != null) {
      return Success(data);
    }
    return Error(ErrorType.GENERIC, 'No user data found');
  }
}

import 'package:domain/domain.dart';

class SettingMfa implements UseCaseResult<bool, MfaSettingParam> {
  final MfaRepo _repo;

  const SettingMfa(this._repo);

  @override
  Future<Result<bool>> call({MfaSettingParam? param}) async {
    return await _repo.mfaSetting(param!.emailMfa, phoneNo: param.phoneNumber);
  }
}

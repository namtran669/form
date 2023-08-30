import 'package:domain/domain.dart';

class RequestOtpAuthResend implements UseCaseResult<AppUserData, void> {
  final AuthenticationRepo _repo;

  const RequestOtpAuthResend(this._repo);

  @override
  Future<Result<AppUserData>> call({void param}) async {
    return await _repo.requestResendOtp();
  }
}

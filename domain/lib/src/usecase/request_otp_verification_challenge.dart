import 'package:domain/domain.dart';

class RequestOtpVerificationChallenge implements UseCaseResult<int, String> {
  final MfaRepo _repo;

  const RequestOtpVerificationChallenge(this._repo);

  @override
  Future<Result<int>> call({String? param}) async {
   return await _repo.requestOtpVerifyChallenge(param!);
  }
}

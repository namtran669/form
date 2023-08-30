import 'package:bloc/bloc.dart';
import 'package:data/src/models/app_user_data_model.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'mfa_state.dart';

class MfaCubit extends Cubit<MfaState> {
  MfaCubit(
    this._settingMfa,
    this._requestOtpVerificationChallenge,
    this._mfaRepo,
  ) : super(MfaInitial());

  final SettingMfa _settingMfa;
  final RequestOtpVerificationChallenge _requestOtpVerificationChallenge;
  final MfaRepo _mfaRepo;

  String? _phoneNo;
  String? _otp;

  set setPhone(String? phone) {
    _phoneNo = phone;
  }

  set setOtp(String? otp) {
    _otp = otp;
  }

  settingMfa({required bool isPhone}) async {
    emit(MfaInProgress());
    var param = isPhone
        ? MfaSettingParam(true, phoneNumber: _phoneNo)
        : MfaSettingParam(false);

    var result = await _settingMfa.call(param: param);
    result.when(
      success: (isSuccess) => emit(MfaSettingSuccess(isSuccess)),
      error: (error) => emit(MfaSettingFail(error.message)),
    );
  }

  requestOtpVerificationChallenge() async {
    if (_phoneNo == null || _phoneNo!.length < 6) {
      emit(const MfaRequestOtpFail(
        'Please enter a valid mobile phone number.',
      ));
      emit(MfaInitial());
    } else {
      emit(MfaRequestOtpInProgress());
      var result = await _requestOtpVerificationChallenge.call(param: _phoneNo);
      result.when(
          success: (data) => emit(const MfaRequestOtpSuccess(true)),
          error: (e) => emit(MfaRequestOtpFail(e.message)));
    }
  }

  verifyOtpAndSettingPhone() async {
    if (_otp == null || _otp!.isEmpty) {
      emit(const MfaVerifyOtpFail('Confirm code is required'));
      emit(MfaInitial());
    } else if (_otp!.length < 6) {
      emit(const MfaVerifyOtpFail('Code must be 6 characters'));
      emit(MfaInitial());
    } else {
      emit(MfaInProgress());
      var result = await _mfaRepo.verifyMfaOtp(_otp!);
      result.when(
        success: (isDone) async {
          var settingResult =
              await _mfaRepo.mfaSetting(true, phoneNo: _phoneNo);
          settingResult.when(
            success: (data) => emit(MfaSettingSuccess(data)),
            error: (error) => emit(MfaSettingFail(error.message)),
          );
        },
        error: (error) => emit(MfaVerifyOtpFail(error.message)),
      );
    }
  }
}

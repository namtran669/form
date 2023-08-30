part of 'mfa_cubit.dart';

abstract class MfaState extends Equatable {
  const MfaState();
}

class MfaInitial extends MfaState {
  @override
  List<Object> get props => [];
}

class MfaInProgress extends MfaState {
  @override
  List<Object?> get props => ['MfaInProgress'];
}

class MfaRequestOtpInProgress extends MfaState {
  @override
  List<Object?> get props => ['MfaRequestOtpProgress'];
}

class MfaVerifyOtpInProgress extends MfaState {
  @override
  List<Object?> get props => ['MfaVerifyOtpInProgress'];
}

class MfaSettingSuccess extends MfaState {
  final bool isSuccess;

  const MfaSettingSuccess(this.isSuccess);

  @override
  List<Object?> get props => [isSuccess];
}

class MfaSettingFail extends MfaState {
  final String msg;

  const MfaSettingFail(this.msg);

  @override
  List<Object?> get props => [msg];
}

class MfaVerifyOtpFail extends MfaState {
  final String msg;

  const MfaVerifyOtpFail(this.msg);

  @override
  List<Object?> get props => [msg];
}

class MfaSettingOtpFail extends MfaState {
  final String msg;

  const MfaSettingOtpFail(this.msg);

  @override
  List<Object?> get props => [msg];
}

class MfaRequestOtpSuccess extends MfaState {
  final bool isSuccess;

  const MfaRequestOtpSuccess(this.isSuccess);

  @override
  List<Object?> get props => [isSuccess];
}

class MfaRequestOtpFail extends MfaState {
  final String msg;

  const MfaRequestOtpFail(this.msg);

  @override
  List<Object?> get props => [msg];
}


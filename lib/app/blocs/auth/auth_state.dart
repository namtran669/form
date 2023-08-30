import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String nextRoute;

  const AuthLoginSuccess(this.nextRoute);
}

class AuthInProgress extends AuthState {
  @override
  List<Object> get props => ['AuthInProgress'];
}

class AuthConfirmingSignIn extends AuthState {
  @override
  List<Object> get props => ['AuthConfirmingSignIn'];
}

class AuthConfirmSignInFail extends AuthState {
  final String message;
  const AuthConfirmSignInFail(this.message);
}

class AuthLoginFailed extends AuthState {
  final String message;
  const AuthLoginFailed(this.message);
}

class AuthConfirmAccountSuccess extends AuthState {

  @override
  List<Object> get props => ['AuthUpdatePasswordSuccess'];
}

class AuthUpdatePasswordFail extends AuthState {
  final String reason;

  const AuthUpdatePasswordFail(this.reason);

  @override
  List<Object> get props => ['AuthUpdatePasswordFail'];
}

class AuthSupportType extends AuthState {
  final BiometricType biometricType;

  const AuthSupportType(this.biometricType);
}

class AuthRequestNewOtpSuccess extends AuthState {
  final String message;

  const AuthRequestNewOtpSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFail extends AuthState {
  final String message;

  const AuthLogoutFail(this.message);
}

class AuthRequestForgotPasswordSuccess extends AuthState {}

class AuthConfirmForgotPasswordSuccess extends AuthState {}

class AuthConfirmForgotPasswordError extends AuthState {
  final String message;

  const AuthConfirmForgotPasswordError(this.message);
}

class AuthRequestForgotPasswordCodeSuccess extends AuthState {}

class AuthRequestForgotPasswordError extends AuthState {
  final String message;

  const AuthRequestForgotPasswordError(this.message);
}



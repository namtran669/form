

class LoginRequest {
  late final String username;
  late final String password;
  LoginRequest(this.username, this.password);
}

class AuthOtpResendBody {
  final String userEmail;
  final String? sessionId;

  AuthOtpResendBody(this.userEmail, this.sessionId);

  Map<String, dynamic> toJson() {
      return {
        'userEmail': userEmail,
        'sessionId': sessionId,
      };
  }
}
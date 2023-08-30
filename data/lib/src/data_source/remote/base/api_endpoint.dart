class ApiEndpoint {
  static const String FORM_DATA = '/form-data';

  static const String MFA_SETTING = '/users/me/mfa-setting';

  static const String OTP_VERIFICATION_CHALLENGE =
      '/otp/verification-challenge';

  static const String VERIFY_CHALLENGE_OTP = '/otp/challenge/verify';

  static const String USER_PROFILE = '/users/me/profile';

  static const String OTP_AUTH_RESEND = '/otp/auth-challenge/resend';

  static const String LIST_STUDY = '/registries?status=active&orderByName=true';

  static const String PATIENT_DATA = '/patient-data';

  static const String PATIENT_TREATMENTS = '/patient-treatments';

  static const String FORMS_UPLOAD_URL = '/forms/uploadUrl';

  static const String COUNT_FORM_STATUS = '$FORM_DATA/count-status';

  static const String FORGOT_PASSWORD = '/users/forgot-password';

  static const String CONFIRM_FORGOT_PASSWORD = '/users/confirm-forgot-password';

  static const String CHANGE_PASSWORD = '/me/password';

  static const String USER_FEEDBACK = '/user-feedback';

  static const String PATIENT = '/patient';

  static const String FORMS_DOWNLOAD_URL = '/forms/downloadUrl';

  static const String QUERIES_SUMMARY = '/queries/summary';

  static const String QUERIES = '/queries';

  static const String USERS_FCM_TOKEN = '/users/fcm-token';

  static const String USERS_LIST_USERS = '/users/list-users';
}

class ApiStatusCode {
  static const int SUCCESS = 200;

  static const int NO_CONTENT = 204;

  static const int ACCESS_TOKEN_EXPIRE = 401;
}

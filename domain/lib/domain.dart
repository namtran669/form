library domain;

import 'src/di/locator.dart';

export 'src/common/error_type.dart';
export 'src/common/result.dart';

export 'src/entities/app_user.dart';
export 'src/entities/form_component.dart';
export 'src/entities/form_component_response.dart';
export 'src/entities/form_data.dart';
export 'src/entities/form_response.dart';
export 'src/entities/patient.dart';
export 'src/entities/study.dart';
export 'src/entities/treatment.dart';
export 'src/entities/treatment_paging.dart';
export 'src/entities/form_response.dart';
export 'src/entities/form_additional_data.dart';
export 'src/entities/patient_document.dart';
export 'src/entities/form_query_details.dart';
export 'src/entities/form_query_comments.dart';

export 'src/params/login_request.dart';
export 'src/params/mfa_request.dart';

export 'src/repositories/authentication_repo.dart';
export 'src/repositories/mfa_repo.dart';
export 'src/repositories/study_treatment_repo.dart';
export 'src/repositories/user_data_repo.dart';
export 'src/repositories/patient_document_repo.dart';
export 'src/repositories/form_query_repo.dart';
export 'src/repositories/telehealth_repo.dart';

export 'src/usecase/base/use_case.dart';
export 'src/usecase/confirm_account.dart';
export 'src/usecase/confirm_sign_in.dart';
export 'src/usecase/fetch_session.dart';
export 'src/usecase/fetch_user_profile.dart';
export 'src/usecase/get_user_data.dart';
export 'src/usecase/request_otp_auth_resend.dart';
export 'src/usecase/request_otp_verification_challenge.dart';
export 'src/usecase/setting_mfa.dart';
export 'src/usecase/sign_in.dart';
export 'src/usecase/sign_out.dart';

class Domain {
  static Future init() async {
    setupLocator();
  }
}

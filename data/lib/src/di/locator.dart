import 'package:core/core.dart';
import 'package:data/src/data_source/remote/change_password_api.dart';
import 'package:data/src/data_source/remote/confirm_sign_in_api.dart';
import 'package:data/src/data_source/remote/count_status_by_study_id_api.dart';
import 'package:data/src/data_source/remote/download_document_api.dart';
import 'package:data/src/data_source/remote/forgot_password_api.dart';
import 'package:data/src/data_source/remote/get_assigned_queries_by_registry_id_api.dart';
import 'package:data/src/data_source/remote/get_comments_by_query_id_api.dart';
import 'package:data/src/data_source/remote/get_forms_by_patient_treatment_id_api.dart';
import 'package:data/src/data_source/remote/get_link_upload_file_api.dart';
import 'package:data/src/data_source/remote/get_list_files_uploaded_api.dart';
import 'package:data/src/data_source/remote/get_queries_summary_api.dart';
import 'package:data/src/data_source/remote/list_study_api.dart';
import 'package:data/src/data_source/remote/list_treatment_api.dart';
import 'package:data/src/data_source/remote/list_users_api.dart';
import 'package:data/src/data_source/remote/mfa_otp_verification_challenge_api.dart';
import 'package:data/src/data_source/remote/mfa_setting_api.dart';
import 'package:data/src/data_source/remote/mfa_verify_otp_api.dart';
import 'package:data/src/data_source/remote/reply_comment_by_query_id_api.dart';
import 'package:data/src/data_source/remote/save_submit_form_api.dart';
import 'package:data/src/data_source/remote/upload_file_api.dart';
import 'package:data/src/data_source/remote/user_feedback_api.dart';
import 'package:data/src/data_source/remote/user_profile_api.dart';
import 'package:data/src/data_source/remote/user_update_fcm_token_api.dart';
import 'package:data/src/repository/auth_repository_impl.dart';
import 'package:data/src/repository/patient_treatment_repo_impl.dart';
import 'package:data/src/repository/user_data_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';

import '../data_source/local/shared_preferences_store.dart';
import '../data_source/remote/auth_resend_otp_api.dart';
import '../data_source/remote/base/api_client.dart';
import '../data_source/remote/confirm_forgot_password_api.dart';
import '../data_source/remote/get_assigned_queries_by_patient_treatment_id_api.dart';
import '../data_source/remote/get_form_data_api.dart';
import '../data_source/remote/sign_in_api.dart';
import '../repository/form_query_repo_impl.dart';
import '../repository/mfa_repository_impl.dart';
import '../repository/patient_document_repo_impl.dart';
import '../repository/telehealth_repo_impl.dart';

final locator = GetIt.instance..allowReassignment = true;

Future setupLocator() async {
  await _registerExternal();
  await _registerApiServices();
  _registerNetworkModules();
  _registerRepository();
  _registerObject();
}

Future _registerExternal() async {
  locator.registerSingleton<FlutterSecureStorage>(
    FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  locator.registerSingleton(SharedPrefsStore(locator()));

  locator.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: locator<AppConfig>().baseUrlEdcBE)),
      instanceName: DIO_EDC_BACKEND);

  locator.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: locator<AppConfig>().baseUrlAws)),
      instanceName: DIO_AWS);

  locator.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: locator<AppConfig>().baseUrlAwsChime)),
      instanceName: DIO_AWS_CHIME);

  final packageInfo = await PackageInfo.fromPlatform();
  locator.registerSingleton<PackageInfo>(packageInfo);
}

Future _registerApiServices() async {
  locator.registerFactory<MfaSettingApi>(() => MfaSettingApiImpl(locator()));

  locator.registerFactory<MfaOtpVerificationChallengeApi>(
      () => MfaOtpVerificationChallengeApiImpl(locator()));

  locator.registerFactory<MfaVerifyOtpApi>(
    () => MfaVerifyOtpApiImpl(locator()),
  );

  locator.registerFactory<UserProfileApi>(
    () => UserProfileApiImpl(locator()),
  );

  locator.registerFactory<OtpAuthResendApi>(
    () => OtpAuthResendApiImpl(locator()),
  );

  locator.registerFactory<ListStudyApi>(
    () => ListStudyApiImpl(locator()),
  );

  locator.registerFactory<ListTreatmentApi>(
    () => ListTreatmentApiImpl(locator()),
  );

  locator.registerFactory<GetFormDataApi>(
    () => FormDataApiImpl(locator()),
  );

  locator.registerFactory<SaveSubmitFormApi>(
    () => SaveSubmitFormApiImpl(locator()),
  );

  locator.registerFactory<GetFormsByPatientTreatmentIdApi>(
    () => GetFormsByPatientTreatmentIdApiImpl(locator()),
  );

  locator.registerFactory<GetLinkUploadFileApi>(
    () => GetLinkUploadFileApiImpl(locator()),
  );

  locator.registerFactory<UploadFileApi>(
    () => UploadFileApiImpl(),
  );

  locator.registerFactory<CountStatusByStudyApi>(
    () => CountStatusByStudyApiImpl(locator()),
  );

  locator.registerFactory<ForgotPasswordApi>(
    () => ForgotPasswordApiImpl(locator()),
  );

  locator.registerFactory<ConfirmForgotPasswordApi>(
    () => ConfirmForgotPasswordApiImpl(locator()),
  );

  locator.registerFactory<ChangePasswordApi>(
    () => ChangePasswordApiImpl(locator()),
  );

  locator.registerFactory<UserFeedbackApi>(
    () => UserFeedbackApiImpl(locator()),
  );

  locator.registerFactory<GetListFilesUploadedApi>(
    () => GetListFilesUploadedApiImpl(locator()),
  );

  locator.registerFactory<DownloadDocumentApi>(
    () => DownloadDocumentApiImpl(locator()),
  );

  locator.registerFactory<GetQueriesSummaryApi>(
    () => GetQueriesSummaryApiImpl(locator()),
  );

  locator.registerFactory<GetCommentsByQueryIdApi>(
    () => GetCommentsByQueryIdApiImpl(locator()),
  );

  locator.registerFactory<ReplyCommentByQueryIdApi>(
    () => ReplyCommentByQueryIdApiImpl(locator()),
  );

  locator.registerFactory<GetAssignedQueriesByRegistryIdApi>(
    () => GetAssignedQueriesByRegistryIdApiImpl(locator()),
  );

  locator.registerFactory<GetQueriesByPatientTreatmentIdApi>(
    () => GetQueriesByPatientTreatmentIdApiImpl(locator()),
  );

  locator.registerFactory<UserUpdateFcmTokenApi>(
    () => UserUpdateFcmTokenApiImpl(locator()),
  );

  locator.registerFactory<ConfirmSignInApi>(
    () => ConfirmSignInApiImpl(locator()),
  );

  locator.registerFactory<SignInApi>(
    () => SignInApiImpl(locator()),
  );

  locator.registerFactory<ListUsersApi>(
        () => ListUsersApiImpl(locator()),
  );
}

Future _registerRepository() async {
  locator.registerFactory<AuthenticationRepo>(() => AuthenticationRepoImpl(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory<UserDataRepo>(() => UserDataRepoImpl(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory<MfaRepo>(() => MfaRepoImpl(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory<PatientTreatmentRepo>(() => PatientTreatmentRepoImpl(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory<PatientDocumentRepo>(() => PatientDocumentRepoImpl(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory<FormQueriesRepo>(() => FormQueriesRepoImpl(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory<TelehealthRepo>(() => TelehealthRepoImpl(
    locator(),
  ));
}

void _registerObject() {
  locator.registerFactory(() => AppUserData());
}

void _registerNetworkModules() {
  locator.registerLazySingleton<EdcApiClient>(() => EdcApiClient(
        _getDio(),
        locator(),
      ));

  locator.registerLazySingleton<AwsApiClient>(() => AwsApiClient(
        _getDio(server: DIO_AWS),
        locator(),
      ));

  locator.registerLazySingleton<AwsChimeApiClient>(() => AwsChimeApiClient(
        _getDio(server: DIO_AWS_CHIME),
        locator(),
      ));
}

Dio _getDio({String server = DIO_EDC_BACKEND}) {
  return locator.get<Dio>(instanceName: server);
}

const String DIO_EDC_BACKEND = 'DIO_EDC_BACKEND';
const String DIO_AWS = 'DIO_AWS';
const String DIO_AWS_CHIME = 'DIO_AWS_CHIME';

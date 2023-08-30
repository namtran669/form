import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:talosix/app/blocs/chat/chat_cubit.dart';
import 'package:talosix/app/blocs/form_counter/form_counter_cubit.dart';
import 'package:talosix/app/blocs/form_incomplete/form_incomplete_bloc.dart';
import 'package:talosix/app/blocs/form_queries/form_queries_cubit.dart';
import 'package:talosix/app/blocs/form_question/form_detail_cubit.dart';
import 'package:talosix/app/blocs/mfa_auth/mfa_cubit.dart';
import 'package:talosix/app/blocs/navigation/navigation_cubit.dart';
import 'package:talosix/app/blocs/study_patient/study_cubit.dart';
import 'package:talosix/app/blocs/treatment/treatment_bloc.dart';
import 'package:talosix/app/blocs/user/user_profile_cubit.dart';

import '../../app/blocs/auth/auth_cubit.dart';
import '../../app/blocs/form_validator/app_form_cubit.dart';
import '../../app/blocs/setting/language_cubit.dart';
import '../app/blocs/app_bottom_bar/app_bottom_bar_bloc.dart';
import '../app/blocs/patient_document/patient_document_cubit.dart';

final locator = GetIt.instance..allowReassignment = true;

Future setupLocator() async {
  await Data.init();
  await Domain.init();
  _registerService();
  _registerBloc();
}

void _registerBloc() {
  locator.registerFactory(() => AuthCubit(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));
  locator.registerFactory(() => LanguageCubit());
  locator.registerFactory(() => AppFormCubit());
  locator.registerFactory(() => AppBottomBarBloc());
  locator.registerFactory(() => MfaCubit(
        locator(),
        locator(),
        locator(),
      ));
  locator.registerFactory(() => AppUserProfileCubit(locator()));
  locator.registerFactory(() => NavigationCubit(locator()));
  locator.registerFactory(() => StudyCubit(locator()));
  locator.registerFactory(() => PatientTreatmentBloc(locator()));
  locator.registerFactory(() => FormDetailCubit(
        locator(),
        locator(),
        locator(),
      ));
  locator.registerFactory(() => PatientDocumentCubit(locator()));
  locator.registerFactory(() => AppUserProfileCubit(locator()));
  locator.registerFactory(() => HomeBloc(locator()));
  locator.registerFactory(() => FormCounterCubit(locator()));
  locator.registerFactory(() => FormQueriesCubit(locator(), locator()));
  locator.registerFactory(() => ChatCubit(
        firebaseFirestore: locator(),
        firebaseAuth: locator(),
        patientDocumentRepo: locator(),
        telehealthRepo: locator(),
      ));
}

void _registerService() {
  locator.registerFactory(() => LocalAuthentication());
  locator.registerFactory(() => FirebaseFirestore.instance);
  locator.registerFactory(() => FirebaseAuth.instance);
}

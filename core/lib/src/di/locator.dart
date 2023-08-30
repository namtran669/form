import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../localizations/strings.dart';

final locator = GetIt.instance..allowReassignment = true;

void setupLocator(AppEnvironment env) {
  locator.registerSingleton(AppConfig(env));
  locator.registerLazySingleton(() => Strings());
}

library data;

import 'package:data/src/data_source/services/app_aws_amplify.dart';

import 'src/di/locator.dart';

export 'src/constants/sign_in_step.dart';
export 'src/models/app_user_data_model.dart';
export 'src/models/form_component_model.dart';

class Data {
  static Future init() async {
    await setupLocator();
    await AppAwsAmplify.init();
  }
}

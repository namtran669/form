import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

import '../../di/locator.dart';


class AppAwsAmplify {
  static Future<void> init() async {
    AmplifyAuthCognito auth = AmplifyAuthCognito();
    Amplify.addPlugins([auth]);

    try {
      await Amplify.configure(locator<AppConfig>().awsCognitoConfig);
    } on AmplifyAlreadyConfiguredException catch(e) {
      if (kDebugMode) {
        print('CAN NOT INIT AMPLIFY: ${e.message}');
      }
    }
  }
}

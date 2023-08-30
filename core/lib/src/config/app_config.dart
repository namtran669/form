enum AppEnvironment { DEV, STAGING, PROD }

class AppConfig {
  late AppEnvironment environment;
  late Map<String, dynamic> _config;

  String get baseUrlEdcBE => _config[_Config.EDC_BACKEND_BASE_URL];

  String get baseUrlAws => _config[_Config.AWS_BASE_URL];

  String get baseUrlAwsChime => _config[_Config.AWS_CHIME_BASE_URL];

  String get awsChimeRegion => _config[_Config.AWS_CHIME_REGION];

  String get awsClientId => _config[_Config.AWS_CLIENT_ID];

  String get awsCognitoConfig => _config[_Config.AWS_COGNITO_CONFIG];

  String get termAndCondition => _config[_Config.AWS_COGNITO_CONFIG];

  AppConfig(AppEnvironment env) {
    _generateConfigWith(env);
  }

  set(AppEnvironment env) => _generateConfigWith(env);

  _generateConfigWith(AppEnvironment env) {
    environment = env;
    switch (environment) {
      case AppEnvironment.DEV:
        _config = _Config.devConstants;
        break;
      case AppEnvironment.STAGING:
        _config = _Config.stagingConstants;
        break;
      case AppEnvironment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }
}

class _Config {
  static const EDC_BACKEND_BASE_URL = 'EDC_BACKEND_BASE_URL';

  static const AWS_BASE_URL = 'AWS_BASE_URL';

  static const AWS_CLIENT_ID = 'AWS_CLIENT_ID';

  static const AWS_COGNITO_CONFIG = 'AWS_COGNITO_CONFIG';

  static const TERM_AND_CONDITION = 'TERM_AND_CONDITION';

  static const AWS_CHIME_BASE_URL = 'AWS_CHIME_BASE_URL';

  static const AWS_CHIME_REGION = 'AWS_CHIME_REGION';

  static Map<String, dynamic> devConstants = {
    EDC_BACKEND_BASE_URL: 'https://registry-api.staging.study.talosix.com',

    AWS_BASE_URL: 'https://cognito-idp.us-east-2.amazonaws.com/',

    AWS_CLIENT_ID: '1tu43k3penkrb7je2vo4ieotvm',

    AWS_COGNITO_CONFIG: _stagingAmplifyConfig,

    TERM_AND_CONDITION: 'https://staging.study.talosix.com/terms-and-conditions',

    AWS_CHIME_BASE_URL: 'https://eehxm1fe8j.execute-api.us-east-1.amazonaws.com/Prod/',

    AWS_CHIME_REGION: 'us-east-1'
  };

  static Map<String, dynamic> stagingConstants = {
    EDC_BACKEND_BASE_URL: 'https://registry-api.staging.study.talosix.com',

    AWS_BASE_URL: 'https://cognito-idp.us-east-2.amazonaws.com/',

    AWS_CLIENT_ID: '1tu43k3penkrb7je2vo4ieotvm',

    AWS_COGNITO_CONFIG: _stagingAmplifyConfig,

    TERM_AND_CONDITION: 'https://staging.study.talosix.com/terms-and-conditions',

    AWS_CHIME_BASE_URL: 'https://6eec8pron7.execute-api.us-east-1.amazonaws.com/staging/',

    AWS_CHIME_REGION: 'us-east-1'
  };

  static Map<String, dynamic> prodConstants = {
    EDC_BACKEND_BASE_URL: 'https://registry-api.platform.study.talosix.com',

    AWS_BASE_URL: 'https://cognito-idp.us-east-2.amazonaws.com/',

    AWS_CLIENT_ID: '8qrhtc6h7is4o15ad4d9adjua',

    AWS_COGNITO_CONFIG: _prodAmplifyConfig,

    TERM_AND_CONDITION: 'https://study.talosix.com/terms-and-conditions',

    AWS_CHIME_BASE_URL: 'https://kvbdw62q5a.execute-api.us-east-1.amazonaws.com/production/',

    AWS_CHIME_REGION: 'us-east-1'
  };

  static const _stagingAmplifyConfig = '''{
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-2_FINZ1Wp8R",
                        "AppClientId": "1tu43k3penkrb7je2vo4ieotvm",
                        "Region": "us-east-2"
                    }
                }
            }
        }
    }
  }''';

  static const _prodAmplifyConfig = '''{
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-2_HySuDN9SH",
                        "AppClientId": "8qrhtc6h7is4o15ad4d9adjua",
                        "Region": "us-east-2"
                    }
                }
            }
        }
    }
  }''';
}

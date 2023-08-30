class MfaSettingBody {
  final bool emailMfa;
  final String mfaOption;
  final String? phoneNumber;


  MfaSettingBody(this.emailMfa, this.mfaOption, {this.phoneNumber});

  Map<String, dynamic> toJson() {
    if(phoneNumber != null) {
      return {
        'emailMfa': true,
        'mfaOption': mfaOption,
        'phoneNumber': phoneNumber
      };
    } else {
      return {
        'emailMfa': true,
        'mfaOption': mfaOption,
      };
    }
  }
}

class MfaSettingParam {
  final bool emailMfa;
  final String? phoneNumber;

  MfaSettingParam(this.emailMfa, {this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'emailMfa': emailMfa,
      'phoneNumber': phoneNumber
    };
  }
}


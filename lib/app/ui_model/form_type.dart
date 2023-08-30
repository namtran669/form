enum FormType {
  registration,
  pef,
  pro,
  other,
  aef,
  cmf,
  pdf,
  pel,
  survey,
  patientDisposition,
  uv,
  ps,
  eConsent,
  patientSurveys
}

extension FormTypeExt on FormType {
  String get name {
    switch (this) {
      case FormType.registration:
        return 'Patient Registration';
      case FormType.pef:
        return 'Patient Enrollment';
      case FormType.pro:
        return 'PRO';
      case FormType.other:
        return 'Other';
      case FormType.aef:
        return 'Adverse Event';
      case FormType.cmf:
        return 'Concomitant Medication';
      case FormType.pdf:
        return 'Protocol Deviation';
      case FormType.pel:
        return 'X';
      case FormType.survey:
        return 'Survey';
      case FormType.patientDisposition:
        return 'Patient Disposition';
      case FormType.uv:
        return 'Unscheduled Visit';
      case FormType.ps:
        return 'Patient Screening';
      case FormType.eConsent:
        return 'eConsent';
      case FormType.patientSurveys:
        return 'Patient Surveys';
    }
  }

  static FormType createFromString(String? shortName) {
    switch (shortName) {
      case 'registration':
        return FormType.registration;
      case 'pef':
        return FormType.pef;
      case 'pro':
        return FormType.pro;
      case 'other':
        return FormType.other;
      case 'aef':
        return FormType.aef;
      case 'cmf':
        return FormType.cmf;
      case 'pdf':
        return FormType.pdf;
      case 'pel':
        return FormType.pel;
      case 'survey':
        return FormType.survey;
      case 'patient_disposition':
        return FormType.patientDisposition;
      case 'uv':
        return FormType.uv;
      case 'ps':
        return FormType.ps;
      case 'eConsent':
        return FormType.eConsent;
      default:
        return FormType.patientSurveys;
    }
  }
}

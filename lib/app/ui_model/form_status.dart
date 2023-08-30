enum FormStatus { active, incomplete, complete, about_to_expire }

extension FormStatusExt on FormStatus {
  static FormStatus createFromString(String status) {
    switch (status) {
      case 'active':
        return FormStatus.active;
      case 'incomplete':
        return FormStatus.incomplete;
      case 'complete':
        return FormStatus.complete;
      case 'about_to_expire':
        return FormStatus.about_to_expire;
      default:
        throw Exception('Invalid status');
    }
  }
}

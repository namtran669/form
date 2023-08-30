enum FormQueryStatus { open, approved, rejected }

extension FormQueryStatusExt on FormQueryStatus {
  static FormQueryStatus createFromString(String status) {
    switch (status) {
      case 'open':
        return FormQueryStatus.open;
      case 'approved':
        return FormQueryStatus.approved;
      case 'rejected':
        return FormQueryStatus.rejected;
      default:
        throw Exception('Invalid status');
    }
  }
}

enum FormQueryFilter { all, open, approved, rejected }
extension FormQueryFilterExt on FormQueryFilter {
  String get name {
    switch(this) {
      case FormQueryFilter.all:
        return 'All';
      case FormQueryFilter.open:
        return 'Open';
      case FormQueryFilter.approved:
        return 'Approved';
      case FormQueryFilter.rejected:
        return 'Rejected';
    }
  }
}
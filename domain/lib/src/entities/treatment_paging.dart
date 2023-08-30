import 'package:equatable/equatable.dart';

import '../../domain.dart';

class TreatmentPaging extends Equatable {
  final int? page;
  final int? pageTotal;
  final int? total;
  final List<Treatment>? treatments;

  TreatmentPaging(
    this.page,
    this.pageTotal,
    this.total,
    this.treatments,
  );

  @override
  List<Object?> get props => [page, pageTotal, total, treatments];
}

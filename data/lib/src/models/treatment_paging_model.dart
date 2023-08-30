import 'package:data/src/models/treatment_model.dart';
import 'package:domain/domain.dart';
import 'package:utils/utils.dart';

class TreatmentPagingModel extends TreatmentPaging {
  TreatmentPagingModel(
      {
      required int? page,
      required int? pageTotal,
      required int? total,
      required List<Treatment>? treatments})
      : super(page, pageTotal, total, treatments);

  factory TreatmentPagingModel.fromJson(Map<String, dynamic> json) {
    return TreatmentPagingModel(
        page: json['page'] ?? 0,
        pageTotal: json['pageTotal'] ?? 0,
        total: json['total'] ?? 0,
        treatments: TreatmentModel.fromList(json['items']));
  }

  static List<TreatmentModel> fromList(List json) {
    return Utils.listFromJson(
      json,
      (item) => TreatmentModel.fromJson(item),
    );
  }
}

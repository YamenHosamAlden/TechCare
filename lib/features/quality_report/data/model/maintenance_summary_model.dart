import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/core/util/helpers/list_warraty_status.dart';
import 'package:tech_care_app/features/finished_receipts/data/models/used_item_model.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/maintenance_summary.dart';

class MaintenanceSummaryModel extends MaintenanceSummary {
  final List<UsedItemModel> items;
  final TranslatableValueModel warrantyType;
  MaintenanceSummaryModel({
    required super.id,
    required this.items,
    required super.totalItemsCost,
    required super.time,
    required this.warrantyType,
    required super.totalOpeationalCost,
    required super.totalCost,
  }) : super(items: items, warrantyType: warrantyType);

  factory MaintenanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceSummaryModel(
        id: json['id'],
        totalItemsCost: json['totalItemsCost'],
        totalOpeationalCost: json['totalOperationalCost'],
        time: json['totalTime'],
        totalCost: json['totalCost'],
        items: (json['items'] as List)
            .map((item) => UsedItemModel.fromJson(item))
            .toList(),
        warrantyType: TranslatableValueModel.fromEntity(
            (json['warrantyStatus'] as String).warrantyStatus));
  }
}

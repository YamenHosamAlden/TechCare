import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/core/util/helpers/list_warraty_status.dart';
import 'package:tech_care_app/features/finished_receipts/data/models/used_item_model.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/device_delivery_report.dart';

class DeviceDeliveryReportModel extends DeviceDeliveryReport {
  final List<UsedItemModel> items;
  final TranslatableValueModel warrantyType;
  DeviceDeliveryReportModel({
    required super.id,
    required super.deviceCode,
    required this.items,
    required super.totalItemsCost,
    required super.time,
    required super.isSalesReturn,
    required this.warrantyType,
    required super.totalOpeationalCost,
    required super.totalCost,
    required super.fixedCost,
  }) : super(items: items, warrantyType: warrantyType);

  factory DeviceDeliveryReportModel.fromJson(Map<String, dynamic> json) {
    return DeviceDeliveryReportModel(
        id: json['id'],
        deviceCode: json['deviceCode'],
        isSalesReturn: json['isSalesReturn'],
        totalItemsCost: json['totalItemsCost'],
        totalOpeationalCost: json['totalOperationalCost'],
        time: json['totalTime'],
        totalCost: json['totalCost'],
        fixedCost: json['fixedCost'] ?? '0.0',
        items: (json['items'] as List)
            .map((item) => UsedItemModel.fromJson(item))
            .toList(),
        warrantyType: TranslatableValueModel.fromEntity(
            (json['warrantyStatus'] as String).warrantyStatus));
  }
}

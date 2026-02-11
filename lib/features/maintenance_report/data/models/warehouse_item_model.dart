import 'package:tech_care_app/features/maintenance_report/domain/entities/warehouse_item.dart';

class WarehouseItemModle extends WarehouseItem {
  WarehouseItemModle(
      {required super.id, required super.itemNumber, required super.itemName});

  factory WarehouseItemModle.fromJson(Map<String, dynamic> json) =>
      WarehouseItemModle(
        id: json['id'],
        itemNumber: json['itemNumber']?.toString() ?? '00000',
        itemName: json['itemName'],
      );
}

import 'package:tech_care_app/features/device_details/domain/entities/maintenance_item.dart';

class MaintenanceItemModel extends MaintenanceItem {
  MaintenanceItemModel(
      {required super.number, required super.name, required super.qty});

  factory MaintenanceItemModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceItemModel(
      number: json['itemNumber'],
      name: json['itemName'] ?? 'undefined',
      qty: json['qty'] ?? 0,
    );
  }
}

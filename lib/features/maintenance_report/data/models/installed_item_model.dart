import 'package:tech_care_app/features/maintenance_report/domain/entities/iinstalled_item.dart';

class InstalledItemModel extends InstalledItem {
  InstalledItemModel({
    required super.id,
    required super.itemNumber,
    required super.itemName,
    required super.qty,
  });

  factory InstalledItemModel.fromJson(Map<String, dynamic> json) {
    return InstalledItemModel(
      id: json['id'],
      itemNumber: json['itemNumber'],
      itemName: json['itemName'],
      qty: json['qty'],
    );
  }

  factory InstalledItemModel.fromEntity(InstalledItem installedItem) {
    return InstalledItemModel(
      id: installedItem.id,
      itemNumber: installedItem.itemNumber,
      itemName: installedItem.itemName,
      qty: installedItem.qty,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'name': itemName,
      'qty': qty,
    };
  }
}

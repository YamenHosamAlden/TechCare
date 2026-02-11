import 'package:tech_care_app/features/finished_receipts/domain/entities/used_item.dart';

class UsedItemModel extends UsedItem {
  UsedItemModel({
    required super.id,
    required super.name,
    required super.price,
    required super.qty,
    required super.cost,
  });

  factory UsedItemModel.fromJson(Map<String, dynamic> json) {
    return UsedItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      qty: json['quantity'],
      cost: json['cost'] ?? ''
    );
  }
}

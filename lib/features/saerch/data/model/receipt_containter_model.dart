import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

class ReceiptContainerModel extends ReceiptContainer {
  ReceiptContainerModel(
      {required super.id,
      required super.receiptNumber,
      required super.customerName,
      required super.customerPhone,
      required super.priority,
      required super.priorityShippingNumber,
      required super.date});

  factory ReceiptContainerModel.fromJson(Map<String, dynamic> json) {
    return ReceiptContainerModel(
      id: json['id'],
      receiptNumber: json['receiptNumber'].toString(),
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      priority: TranslatableValueModel.fromJson(key: 'priority', json: json),
      priorityShippingNumber: json['priorityShippingNumber'],
      date: DateTime.parse(json['date']),
    );
  }
}

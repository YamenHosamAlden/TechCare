import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';

class ReceiptModel extends Receipt {
  final TranslatableValueModel priority;
  ReceiptModel({
    required super.id,
    // required super.receiptContainerId,
    required super.receiptNumber,
    required super.groupId,
    required super.groupName,
    required this.priority,
    required super.customerName,
    required super.customerPhoneNumber,
    required super.hasReturnedDevice,
    super.userId,
    required super.createdAt,
  }) : super(priority: priority);

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'],
      // receiptContainerId: json['receipt_container_id'],
      receiptNumber: json['receiptNumber'],
      groupId: json['groupId'],
      groupName: json['groupName'],
      priority: TranslatableValueModel.fromJson(key: 'priority', json: json),
      customerName: json['customerName'],
      customerPhoneNumber: json['customerPhone'],
      userId: json['userId'],
      hasReturnedDevice: json['hasReturnedDevice'],
      createdAt: DateTime.parse(json['receiptDate']),
    );
  }
}

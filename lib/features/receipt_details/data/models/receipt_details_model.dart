import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/receipt_details/data/models/device_info_model.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/receipt_details.dart';

class ReceiptDetailsModel extends ReceiptDetails {
  ReceiptDetailsModel({
    required super.id,
    required super.receiptNumber,
    required super.createdBy,
    required super.customerName,
    required super.customerPhone,
    required super.priority,
    required super.groupName,
    required super.createdAt,
    required super.device,
    required super.shippingNumber,
    required super.assignTo,
  });

  factory ReceiptDetailsModel.fromJson(Map<String, dynamic> json) =>
      ReceiptDetailsModel(
        id: json['id'],
        receiptNumber: json['receiptNumber'],
        createdBy: json['createdBy'] ?? '',
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        priority: TranslatableValueModel.fromJson(key: 'priority', json: json),
        shippingNumber: json['priorityShippingNumber'],
        groupName: json['groupName'],
        assignTo: json['userName'],
        createdAt: DateTime.parse(json['receiptDate']),
        device: (json['devices'] as List)
            .map((deviceJson) => DeviceInfoModel.fromJson(deviceJson))
            .toList(),
      );
}

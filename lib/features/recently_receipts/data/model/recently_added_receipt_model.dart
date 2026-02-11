// import 'package:tech_care_app/core/models/translatable_value_model.dart';
// import 'package:tech_care_app/features/recently_receipts/domain/entity/recenty_added_receipt.dart';

// class RecentyReceiptModel extends RecentlyReceipt {
//   RecentyReceiptModel(
//       {required super.id,
//       required super.receiptNumber,
//       required super.receiptDate,
//       required super.customerName,
//       required super.customerPhone,
//       required super.priority,
//       required super.priorityShippingNumber,
//       required super.groupId,
//       required super.groupName,
//       required super.userId});

//   factory RecentyReceiptModel.fromJson(Map<String, dynamic> json) =>
//       RecentyReceiptModel(
//         id: json['id'],
//         receiptNumber: json['receiptNumber'],
//         receiptDate: DateTime.parse(json['receiptDate']),
//         customerName: json['customerName'],
//         customerPhone: json['customerPhone'],
//         priority: TranslatableValueModel.fromJson(key: 'priority', json: json),
//         priorityShippingNumber: json['priorityShippingNumber'],
//         groupId: json['groupId'],
//         groupName: json['groupName'],
//         userId: json['userId'],
//       );
// }

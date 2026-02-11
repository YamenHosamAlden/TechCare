import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/device_info.dart';

class ReceiptDetails extends Equatable {
  final int id;
  final String receiptNumber;
  final String createdBy;
  final String customerName;
  final String customerPhone;
  final TranslatableValue priority;
  final String? shippingNumber;
  final String groupName;
  final String? assignTo;
  final DateTime createdAt;
  final List<DeviceInfo> device;

  ReceiptDetails({
    required this.id,
    required this.receiptNumber,
    required this.createdBy,
    required this.customerName,
    required this.customerPhone,
    required this.priority,
    required this.shippingNumber,
    required this.groupName,
    required this.assignTo,
    required this.createdAt,
    required this.device,
  });
  ReceiptDetails copyWith({
    int? id,
    String? receiptNumber,
    String? createdBy,
    String? customerName,
    String? customerPhone,
    TranslatableValue? priority,
    String? shippingNumber,
    String? groupName,
    String? assignTo,
    DateTime? createdAt,
    List<DeviceInfo>? device,
  }) =>
      ReceiptDetails(
          id: id ?? this.id,
          receiptNumber: receiptNumber ?? this.receiptNumber,
          createdBy: createdBy ?? this.createdBy,
          customerName: customerName ?? this.customerName,
          customerPhone: customerPhone ?? this.customerPhone,
          priority: priority ?? this.priority,
          shippingNumber: shippingNumber ?? this.shippingNumber,
          groupName: groupName ?? this.groupName,
          assignTo: assignTo ?? this.assignTo,
          createdAt: createdAt ?? this.createdAt,
          device: device ?? this.device);

  @override
  List<Object?> get props => [
        receiptNumber,
        createdBy,
        customerName,
        customerPhone,
        priority,
        shippingNumber,
        groupName,
        assignTo,
        createdAt,
        device,
        device.length,
        id,
      ];
}

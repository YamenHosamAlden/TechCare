import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/payment.dart';

class ContainerDetails extends Equatable {
  final int id;
  final String receiptNumber;
  final String customerName;
  final String customerPhone;
  final TranslatableValue priority;
  final String? priorityShippingNumber;
  final DateTime date;
  final List<Payment> payments;
  final List<DeviceInfo> devices;
  final String receiptPrintingUrl;

  ContainerDetails({
    required this.id,
    required this.receiptNumber,
    required this.customerName,
    required this.customerPhone,
    required this.priority,
    required this.priorityShippingNumber,
    required this.date,
    required this.payments,
    required this.devices,
    required this.receiptPrintingUrl,
  });

  ContainerDetails copyWith({
    final int? id,
    final String? receiptNumber,
    final String? customerName,
    final String? customerPhone,
    final TranslatableValue? priority,
    final String? priorityShippingNumber,
    final DateTime? date,
    final List<Payment>? payments,
    final List<DeviceInfo>? devices,
    final String? receiptPrintingUrl,
  }) =>
      ContainerDetails(
          id: id ?? this.id,
          receiptNumber: receiptNumber ?? this.receiptNumber,
          customerName: customerName ?? this.customerName,
          customerPhone: customerPhone ?? this.customerPhone,
          priority: priority ?? this.priority,
          priorityShippingNumber:
              priorityShippingNumber ?? this.priorityShippingNumber,
          date: date ?? this.date,
          payments: payments ?? this.payments,
          devices: devices ?? this.devices,
          receiptPrintingUrl: receiptPrintingUrl ?? this.receiptPrintingUrl);

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        customerName,
        customerPhone,
        priority,
        priorityShippingNumber,
        date,
        payments,
        devices,
        devices.length,
        receiptPrintingUrl,
      ];
}

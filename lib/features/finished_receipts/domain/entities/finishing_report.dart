import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/device_delivery_report.dart';

class FinishingReport extends Equatable {
  final List<DeviceDeliveryReport> devices;
  final String time;
  final String totalItemsCost;
  final String totalOperationalCost;
  final String finalCost;
  final String prefinalCost;
  final String totalFixedCost;
  final String receiptNumber;
  final String customerName;
  final String customerPhone;
  final TranslatableValue priority;
  final String? shippingNumber;
  final DateTime date;

  FinishingReport({
    required this.devices,
    required this.time,
    required this.totalItemsCost,
    required this.totalOperationalCost,
    required this.receiptNumber,
    required this.customerName,
    required this.customerPhone,
    required this.priority,
    required this.shippingNumber,
    required this.date,
    required this.finalCost,
    required this.prefinalCost,
    required this.totalFixedCost,
  });

  FinishingReport copyWith({
    List<DeviceDeliveryReport>? devices,
    String? time,
    String? totalItemsCost,
    String? totalOperationalCost,
    String? finalCost,
    String? prefinalCost,
    String? totalFixedCost,
    String? receiptNumber,
    String? customerName,
    String? customerPhone,
    TranslatableValue? priority,
    String? shippingNumber,
    DateTime? date,
  }) =>
      FinishingReport(
        devices: devices ?? this.devices,
        time: time ?? this.time,
        totalItemsCost: totalItemsCost ?? this.totalItemsCost,
        totalOperationalCost: totalOperationalCost ?? this.totalOperationalCost,
        finalCost: finalCost ?? this.finalCost,
        prefinalCost: prefinalCost ?? this.prefinalCost,
        totalFixedCost: totalFixedCost ?? this.totalFixedCost,
        receiptNumber: receiptNumber ?? this.receiptNumber,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        priority: priority ?? this.priority,
        shippingNumber: shippingNumber ?? this.shippingNumber,
        date: date ?? this.date,
      );

  @override
  List<Object?> get props => [
        devices,
        time,
        totalOperationalCost,
        totalItemsCost,
        receiptNumber,
        customerName,
        priority,
        shippingNumber,
        date,
        finalCost,
        prefinalCost,
        totalFixedCost
      ];
}

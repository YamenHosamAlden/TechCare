import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/finished_receipts/data/models/device_delivery_report_model.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/finishing_report.dart';

class FinishingReportModel extends FinishingReport {
  final List<DeviceDeliveryReportModel> devices;

  final TranslatableValueModel priority;
  FinishingReportModel({
    required this.devices,
    required this.priority,
    required super.time,
    required super.totalItemsCost,
    required super.totalOperationalCost,
    required super.finalCost,
    required super.shippingNumber,
    required super.receiptNumber,
    required super.customerName,
    required super.customerPhone,
    required super.date,
    required super.prefinalCost,
    required super.totalFixedCost,
  }) : super(devices: devices, priority: priority);

  factory FinishingReportModel.fromJson(Map<String, dynamic> json) {
    return FinishingReportModel(
      devices: (json['devices'] as List)
          .map<DeviceDeliveryReportModel>(
              (device) => DeviceDeliveryReportModel.fromJson(device))
          .toList(),
      prefinalCost: json['prefinalCost'],
      time: json['totalTime'],
      totalItemsCost: json['totalItemsCost'],
      totalOperationalCost: json['totalOperationalCost'],
      finalCost: json['finalCost'],
      totalFixedCost: (json['totalFixed'] as num).toDouble().toString(),
      priority: TranslatableValueModel.fromJson(key: 'priority', json: json),
      shippingNumber: json['priorityShippingNumber'],
      receiptNumber: json['receiptNumber'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      date: DateTime.parse(json['date']),
    );
  }
}

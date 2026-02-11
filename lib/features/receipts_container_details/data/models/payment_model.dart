import 'package:tech_care_app/features/receipts_container_details/data/models/device_reference_model.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/payment.dart';

class PaymentModel extends Payment {
  final List<DeviceReferenceModel> devices;
  PaymentModel({
    required super.amount,
    required super.date,
    required super.expectedCost,
    required super.note,
    required this.devices,
  }) : super(
          devices: devices,
        );

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      amount: json['paidAmount'],
      date: DateTime.parse(json['date']),
      expectedCost: json['expectedAmount'],
      note: json['note'],
      devices: (json['devices'] as List)
          .map<DeviceReferenceModel>((deviceReferenceJson) =>
              DeviceReferenceModel.fromJson(deviceReferenceJson))
          .toList(),
    );
  }
}

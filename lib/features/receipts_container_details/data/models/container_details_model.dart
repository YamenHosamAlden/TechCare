import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/device_info_model.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/payment_model.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';

class ContainerDetailsModel extends ContainerDetails {
  final List<DeviceInfoModel> devices;
  final List<PaymentModel> payments;

  ContainerDetailsModel(
      {required super.id,
      required super.receiptNumber,
      required super.customerName,
      required super.customerPhone,
      required super.priority,
      required super.priorityShippingNumber,
      required super.date,
      required this.payments,
      required this.devices,
      required super.receiptPrintingUrl})
      : super(
          devices: devices,
          payments: payments,
        );

  factory ContainerDetailsModel.fromJson(Map<String, dynamic> json) {
    return ContainerDetailsModel(
        id: json['id'],
        receiptNumber: json['receiptNumber'],
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        priority: TranslatableValueModel.fromJson(
            key: 'priority', json: json, object: json['priority']['en']),
        priorityShippingNumber: json['priorityShippingNumber'],
        date: DateTime.parse(json['date']),
        payments: (json['payments'] as List)
            .map<PaymentModel>(
                (paymentJson) => PaymentModel.fromJson(paymentJson))
            .toList(),
        devices: (json['devices'] as List)
            .map<DeviceInfoModel>(
                (deviceJson) => DeviceInfoModel.fromJson(deviceJson))
            .toList(),
        receiptPrintingUrl: json['receiptPrintingUrl']);
  }

  factory ContainerDetailsModel.fromEntity(ContainerDetails containerDetails) =>
      ContainerDetailsModel(
          id: containerDetails.id,
          receiptNumber: containerDetails.receiptNumber,
          customerName: containerDetails.customerName,
          customerPhone: containerDetails.customerPhone,
          priority:
              TranslatableValueModel.fromEntity(containerDetails.priority),
          priorityShippingNumber: containerDetails.priorityShippingNumber,
          date: containerDetails.date,
          payments: containerDetails.payments as List<PaymentModel>,
          devices: containerDetails.devices as List<DeviceInfoModel>,
          receiptPrintingUrl: containerDetails.receiptPrintingUrl);

  Map<String, dynamic> toJson() {
    print("what is the tojson ${priority.object}");
    final json = {
      "customer_name": customerName,
      "customer_phone": customerPhone,
      'priority': priority.object,
      "priority_shipping_number": priorityShippingNumber
    };

    return json;
  }
}

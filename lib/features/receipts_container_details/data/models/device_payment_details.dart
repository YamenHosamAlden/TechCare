import 'package:tech_care_app/features/finished_receipts/data/models/used_item_model.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_payment_details.dart';

class DevicePaymentDetailsModel extends DevicePaymentDetails {
  final List<UsedItemModel> usedItemModel;
  DevicePaymentDetailsModel({
    required super.deviceCode,
    required super.totalTime,
    required super.itemsCost,
    required super.operationalCost,
    required super.totalCost,
    required this.usedItemModel,
    required super.paidAmount,
  }) : super(usedItem: usedItemModel);
  factory DevicePaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      DevicePaymentDetailsModel(
        deviceCode: json['deviceCode'],
        totalTime: json['totalTime'],
        totalCost: json['totalCost'],
        operationalCost: json['operationalCost'],
        usedItemModel: (json['items'] as List)
            .map((item) => UsedItemModel.fromJson(item))
            .toList(),
        itemsCost: json['itemsCost'],
        paidAmount: json['paidAmount'],
      );
}

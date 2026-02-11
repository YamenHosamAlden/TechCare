import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/device_type_model.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_details.dart';

class DeviceInfoModel extends DeviceInfo {
  final DeviceTypeModel type;
  DeviceInfoModel(
      {super.id,
      required super.deviceCode,
      required super.serialNumber,
      required super.qty,
      required this.type,
      required super.model,
      super.assignId,
      super.assignName,
      super.status,
      super.statusLable})
      : super(type: type);

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      DeviceInfoModel(
        id: json['id'],
        deviceCode: json['deviceCode'].toString(),
        serialNumber: json['deviceSerialNumber'],
        qty: json['deviceQty'].toString(),
        type: DeviceTypeModel.fromJson(json['deviceType']),
        model: json['deviceModel'],
        assignName: json['assignName'],
        assignId: json['assignId'],
        statusLable:
            TranslatableValueModel.fromJson(key: 'statusLabel', json: json),
        status: TranslatableValueModel.fromJson(key: 'status', json: json),
      );

  factory DeviceInfoModel.fromDeviceDetails(DeviceDetails deviceDetails) {
    return DeviceInfoModel(
      deviceCode: deviceDetails.deviceCode,
      serialNumber: deviceDetails.deviceSerialNumber,
      qty: deviceDetails.deviceQty,
      type: DeviceTypeModel.fromEntity(deviceDetails.deviceType),
      model: deviceDetails.deviceModel,
    );
  }
}

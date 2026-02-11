import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/device_type_model.dart';
import 'package:tech_care_app/features/saerch/domain/entity/device_info.dart';

class DeviceInfoModel extends DeviceInfo {
 final  DeviceTypeModel type;
  DeviceInfoModel({
    required super.id,
    required super.deviceCode,
    required super.serialNumber,
    required super.qty,
    required this.type,
    required super.model,
    required super.assignId,
    required super.assignName,
    required super.status,
    required super.statusLable
  }):super(type: type);

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      DeviceInfoModel(
        id: json['id'],
        deviceCode: json['deviceCode'].toString(),
        serialNumber: json['deviceSerialNumber'],
        qty: json['deviceQty'].toString(),
        type: DeviceTypeModel.fromJson(json['deviceType']),
        model: json['deviceModel'],
        assignName: json['assignName'],
        statusLable: TranslatableValueModel.fromJson(key: 'statusLabel', json: json),
        assignId: json['assignId'],
           status: TranslatableValueModel.fromJson(key: 'status', json: json),
      );
}

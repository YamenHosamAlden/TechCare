import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/core/util/helpers/list_warraty_status.dart';
import 'package:tech_care_app/features/create_receipt/data/models/device_type_model.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_info.dart';

class DeviceInfoModel extends DeviceInfo {
  final DeviceTypeModel type;
  final TranslatableValueModel warrantyType;
  DeviceInfoModel({
    required super.id,
    required super.receiptId,
    required super.deviceCode,
    required super.images,
    required super.serialNumber,
    required super.qty,
    required this.type,
    required super.model,
    required super.itemName,
    required super.problemDescription,
    required super.attachments,
    required super.sourceCompany,
    required this.warrantyType,
    required super.reasonForWarranty,
    required super.status,
    required super.statusLable,
    required super.assignId,
    required super.assignName,
  }) : super(
          type: type,
          warrantyType: warrantyType,
        );

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoModel(
      id: json['id'],
      receiptId: json['receiptId'],
      deviceCode: json['deviceCode'],
      images: (json['images'] as List).map((e) => e.toString()).toList(),
      serialNumber: json['deviceSerialNumber'],
      qty: json['deviceQty'].toString(),
      type: DeviceTypeModel.fromJson(json['deviceType']),
      model: json['deviceModel'],
      itemName: json['deviceName'],
      problemDescription: json['problemDescription'],
      attachments: json['deviceAttachments'],
      sourceCompany: json['companyName'],
      warrantyType: TranslatableValueModel.fromEntity(
          (json['deviceWarranty'] as String).warrantyStatus),
      reasonForWarranty: json['warrantyReason'],
      status: TranslatableValueModel.fromJson(key: 'status', json: json),
      statusLable:
          TranslatableValueModel.fromJson(key: 'statusLabel', json: json),
      assignName: json['assignName'],
      assignId: json['assignId'],
    );
  }
}

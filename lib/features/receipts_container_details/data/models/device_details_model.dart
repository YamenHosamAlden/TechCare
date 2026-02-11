import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/core/util/helpers/list_warraty_status.dart';
import 'package:tech_care_app/features/create_receipt/data/models/company_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/device_type_model.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_details.dart';
import 'package:path/path.dart';

class DeviceDetailsModel extends DeviceDetails {
  final DeviceTypeModel deviceType;
  final CompanyModel company;
  final TranslatableValueModel deviceWarranty;

  DeviceDetailsModel(
      {required super.deviceCode,
      required super.deviceSerialNumber,
      required this.deviceType,
      required super.deviceModel,
      required super.deviceName,
      required super.deviceQty,
      required super.problemDescription,
      required super.deviceAttachments,
      required this.company,
      required this.deviceWarranty,
      required super.warrantyReason,
      super.newDeviceType,
      super.deletedImages,
      super.fileImages,
      required super.images})
      : super(
          deviceType: deviceType,
          company: company,
          deviceWarranty: deviceWarranty,
        );

  factory DeviceDetailsModel.fromJson(Map<String, dynamic> json) =>
      DeviceDetailsModel(
        deviceCode: json['deviceCode'],
        deviceSerialNumber: json['deviceSerialNumber'],
        deviceType: DeviceTypeModel.fromJson(json['deviceType']),
        deviceModel: json['deviceModel'],
        deviceName: json['deviceName'] ?? '',
        deviceQty: json['deviceQty'].toString(),
        problemDescription: json['problemDescription'],
        deviceAttachments: json['deviceAttachments'] ?? "",
        company: CompanyModel.fromJson(json['company']),
        deviceWarranty: TranslatableValueModel.fromEntity(
            (json['deviceWarranty'] as String).warrantyStatus),
        warrantyReason: json['warrantyReason'] ?? "",
        images: (json['images'] as List).map((e) => e.toString()).toList(),
      );

  DeviceDetailsModel.fromEntity(DeviceDetails deviceDetails)
      : this(
            deviceCode: deviceDetails.deviceCode,
            images: deviceDetails.images,
            fileImages: deviceDetails.fileImages,
            deletedImages: deviceDetails.deletedImages,
            deviceModel: deviceDetails.deviceModel,
            deviceName: deviceDetails.deviceName,
            deviceQty: deviceDetails.deviceQty,
            deviceAttachments: deviceDetails.deviceAttachments,
            deviceSerialNumber: deviceDetails.deviceSerialNumber,
            deviceType: DeviceTypeModel.fromEntity(deviceDetails.deviceType),
            newDeviceType:deviceDetails.newDeviceType,
            deviceWarranty:
                TranslatableValueModel.fromEntity(deviceDetails.deviceWarranty),
            problemDescription: deviceDetails.problemDescription,
            warrantyReason: deviceDetails.warrantyReason,
            company: CompanyModel.fromEntity(deviceDetails.company));

  Map<String, dynamic> toJson() {
    final json = {
      "device_code": deviceCode,
      "device_name": deviceName,
      "device_type": newDeviceType,
      "device_model": deviceModel,
      "device_qty": deviceQty,
      "device_serial_number": deviceSerialNumber,
      "device_warranty": deviceWarranty.object,
      "warranty_reason": warrantyReason,
      "company_id": company.id,
      "device_attachments": deviceAttachments,
      "problem_description": problemDescription,
      "deleted_images":
          deletedImages?.map((image) => jsonEncode(image)).toList().toString(),
      "new_images_count": fileImages?.length ?? 0
    };
    if (fileImages != null || fileImages!.isNotEmpty) {
      for (var i = 0; i < fileImages!.length; i++) {
        final imageFile = fileImages!.elementAt(i);
        json.addAll({
          'new_image$i': MultipartFile.fromFileSync('.' + imageFile.path,
              filename: basename(imageFile.path))
        });
      }
    }

    return json;
  }
}

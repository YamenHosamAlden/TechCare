import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_reference.dart';

class DeviceReferenceModel extends DeviceReference {
  DeviceReferenceModel({required super.id, required super.deviceCode});

  factory DeviceReferenceModel.fromJson(Map<String, dynamic> json) {
    return DeviceReferenceModel(
      id: json['id'],
      deviceCode: json['deviceCode'],
    );
  }
}

import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';

class DeviceTypeModel extends DeviceType {
  DeviceTypeModel({required super.id, required super.name});
  factory DeviceTypeModel.fromJson(Map<String, dynamic> json) {
    return DeviceTypeModel(
        id: json['id'],
        name: TranslatableValueModel.fromJson(key: 'name', json: json));
  }

  DeviceTypeModel.fromEntity(DeviceType deviceType)
      : this(id: deviceType.id, name: deviceType.name);
}

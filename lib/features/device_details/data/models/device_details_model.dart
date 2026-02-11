import 'package:tech_care_app/features/device_details/data/models/device_info_model.dart';
import 'package:tech_care_app/features/device_details/data/models/process_model.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_details.dart';

class DeviceDetailsModel extends DeviceDetails {
  DeviceDetailsModel({required super.deviceInfo, required super.process});

  factory DeviceDetailsModel.fromJson(Map<String, dynamic> json) {
    return DeviceDetailsModel(
      deviceInfo: DeviceInfoModel.fromJson(json['deviceDetails']),
      process: ProcessModel.fromJson(json['processingDetails']),
    );
  }
}

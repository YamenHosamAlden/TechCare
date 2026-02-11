import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process.dart';

class DeviceDetails extends Equatable {
  final DeviceInfo deviceInfo;
  final Process process;

  DeviceDetails({
    required this.deviceInfo,
    required this.process,
  });

  @override
  List<Object?> get props => [deviceInfo, process];
  // List<Object?> get props => [deviceInfo];
}

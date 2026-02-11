import 'package:equatable/equatable.dart';

class DeviceReference extends Equatable {
  final int id;
  final String deviceCode;

  DeviceReference({required this.id, required this.deviceCode});

  @override
  List<Object?> get props => [
        id,
        deviceCode,
      ];
}

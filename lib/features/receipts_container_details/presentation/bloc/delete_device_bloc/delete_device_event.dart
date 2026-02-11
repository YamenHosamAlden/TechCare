part of 'delete_device_bloc.dart';

class DeleteDeviceEvent extends Equatable {
  final int deviceId;
  const DeleteDeviceEvent({required this.deviceId});

  @override
  List<Object> get props => [];
}

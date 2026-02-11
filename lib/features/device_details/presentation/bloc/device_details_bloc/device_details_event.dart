part of 'device_details_bloc.dart';

abstract class DeviceDetailsEvent extends Equatable {
  const DeviceDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetDeviceInfo extends DeviceDetailsEvent {
  final int? deviceID;
  final String? deviceCode;
  GetDeviceInfo({
    this.deviceID,
    this.deviceCode,
  });
}

class _TickEvent extends DeviceDetailsEvent {}

class StartTimer extends DeviceDetailsEvent {}

class PauseTimer extends DeviceDetailsEvent {}

class UnreceiveDevice extends DeviceDetailsEvent {
  final String reason;
  UnreceiveDevice({required this.reason});
}

class AddNote extends DeviceDetailsEvent {
  final String note;
  AddNote({required this.note});
}

class AddReport extends DeviceDetailsEvent {
  final ProcessReport report;
  AddReport({required this.report});
}

class _RemoveRecentlyAddedReportState extends DeviceDetailsEvent {}

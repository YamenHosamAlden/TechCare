part of 'device_payment_details_bloc.dart';

sealed class DevicePaymentDetailsEvent extends Equatable {
  const DevicePaymentDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadDevicePeymentDetails extends DevicePaymentDetailsEvent {
  final int deviceId;
  const LoadDevicePeymentDetails({required this.deviceId});
}

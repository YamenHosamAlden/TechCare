part of 'device_payment_details_bloc.dart';

class DevicePaymentDetailsState extends Equatable {
  final bool isLoading;
  final DevicePaymentDetails? devicePaymentDetails;

  const DevicePaymentDetailsState({
    this.isLoading = false,
    this.devicePaymentDetails,
  });

  DevicePaymentDetailsState.init()
      : this(
          isLoading: true,
        );
  DevicePaymentDetailsState copyWith({
    final bool? isLoading,
    final DevicePaymentDetails? devicePaymentDetails,
  }) =>
      DevicePaymentDetailsState(
        isLoading: isLoading ?? this.isLoading,
        devicePaymentDetails: devicePaymentDetails ?? this.devicePaymentDetails,
      );

  @override
  List<Object?> get props => [
        isLoading,
        devicePaymentDetails,
      ];
}

class DevicePaymentDetailsErrorState extends DevicePaymentDetailsState {
  final TranslatableValue? errorMessage;

  DevicePaymentDetailsErrorState({this.errorMessage});
}

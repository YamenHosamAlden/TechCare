import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_payment_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/load_device_payment_usecase.dart';

part 'device_payment_details_event.dart';
part 'device_payment_details_state.dart';

class DevicePaymentDetailsBloc
    extends Bloc<DevicePaymentDetailsEvent, DevicePaymentDetailsState> {
  LoadDevicePaymentDetailsUsecase loadDevicePaymentDetailsUsecase;
  DevicePaymentDetailsBloc({
    required this.loadDevicePaymentDetailsUsecase,
  }) : super(DevicePaymentDetailsState.init()) {
    on<LoadDevicePeymentDetails>(_loadDevicePeymentDetails);
  }

  FutureOr<void> _loadDevicePeymentDetails(LoadDevicePeymentDetails event,
      Emitter<DevicePaymentDetailsState> emit) async {
    emit(state.copyWith(
      isLoading: true,
    ));
    await loadDevicePaymentDetailsUsecase(event.deviceId).then((value) =>
        value.fold(
            (failure) => emit(DevicePaymentDetailsErrorState(
                errorMessage: mapFailureToMsg(failure))),
            (devicePaymentDetails) => emit(state.copyWith(
                  isLoading: false,
                  devicePaymentDetails: devicePaymentDetails,
                ))));
  }
}

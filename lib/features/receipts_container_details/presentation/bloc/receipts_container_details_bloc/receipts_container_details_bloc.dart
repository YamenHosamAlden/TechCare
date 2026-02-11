import 'dart:async';
import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/load_container_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/stream_receipts_container_details_event_usecae.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';

part 'receipts_container_details_event.dart';
part 'receipts_container_details_state.dart';

class ReceiptsContainerDetailsBloc
    extends Bloc<ReceiptsContainerDetailsEvent, ReceiptsContainerDetailsState> {
  final LoadContainerDetailsUsecase loadContainerDetailsUsecase;
  final StreamReceiptsContainerDetailsEventUsecae
      streamReceiptsContainerDetailsEventUsecae;
  late final StreamSubscription<ReceiptsContainerDetailsEvent>
      _deviceStreamSubscription;

  ReceiptsContainerDetailsBloc(
      {required this.loadContainerDetailsUsecase,
      required this.streamReceiptsContainerDetailsEventUsecae})
      : super(ReceiptsContainerDetailsState.initial()) {
    on<LoadContainerDetails>(_onLoadContainerDetails);
    on<RemoveFromDeviceList>(_onRemoveFromDeviceList);
    on<EditDevice>(_onEditDevice);
    on<EditReceipt>(_onEditReceipt);

    streamReceiptsContainerDetailsEventUsecae(Void).then((value) {
      value.fold(
        (l) => null,
        (eventsStream) {
          _deviceStreamSubscription = eventsStream.listen((event) {
            this.add(event);
          });
        },
      );
    });
  }

  FutureOr<void> _onLoadContainerDetails(LoadContainerDetails event,
      Emitter<ReceiptsContainerDetailsState> emit) async {
    emit(state.copyWith(pageLoading: true));
    await loadContainerDetailsUsecase(Params(
            containerId: event.containerId, displayType: event.displayType))
        .then((value) => value.fold((failure) {
              emit(ReceiptsContainerDetailsErrorState(
                  errorMessage: mapFailureToMsg(failure)));
            }, (container) {
              emit(state.copyWith(
                  pageLoading: false, containerDetails: container));
            }));
  }

  FutureOr<void> _onEditReceipt(
      EditReceipt event, Emitter<ReceiptsContainerDetailsState> emit) {
    ContainerDetails containerDetails = state.containerDetails!.copyWith(
      id: event.containerDetails.id,
      customerName: event.containerDetails.customerName,
      customerPhone: event.containerDetails.customerPhone,
      priority: event.containerDetails.priority,
      priorityShippingNumber: event.containerDetails.priorityShippingNumber
    );

    emit(state.copyWith(containerDetails: containerDetails));
  }

  FutureOr<void> _onEditDevice(
      EditDevice event, Emitter<ReceiptsContainerDetailsState> emit) {
    List<DeviceInfo> deviceList = state.containerDetails?.devices ?? [];
    deviceList = deviceList.map((device) {
      if (device.id == event.deviceId) {
        return device.copyWith(
          deviceCode: event.deviceInfo.deviceCode,
          serialNumber: event.deviceInfo.serialNumber,
          type: event.deviceInfo.type,
          model: event.deviceInfo.model,
          qty: event.deviceInfo.qty,
        );
      }
      return device;
    }).toList();
    ;
    emit(state.copyWith(
        containerDetails:
            state.containerDetails?.copyWith(devices: deviceList)));
  }

  FutureOr<void> _onRemoveFromDeviceList(
      RemoveFromDeviceList event, Emitter<ReceiptsContainerDetailsState> emit) {
    final List<DeviceInfo> devicesList =
        List.from(state.containerDetails?.devices ?? []);
    devicesList.removeWhere((device) => device.id == event.deviceId);

    emit(state.copyWith(
        containerDetails:
            state.containerDetails?.copyWith(devices: devicesList)));
  }

  @override
  Future<void> close() {
    _deviceStreamSubscription.cancel();

    return super.close();
  }
}

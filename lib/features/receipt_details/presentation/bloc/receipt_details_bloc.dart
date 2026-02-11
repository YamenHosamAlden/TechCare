import 'dart:async';
import 'dart:ffi';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/receipt_details.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/get_receipt_details_by_device_code_usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/get_receipt_details_by_receipt_id_usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/receive_devices_usecse.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/stream_receipts_details_event_usecae.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

part 'receipt_details_event.dart';
part 'receipt_details_state.dart';

class ReceiptDetailsBloc
    extends Bloc<ReceiptDetailsEvent, ReceiptDetailsState> {
  final GetReceiptDetailsByReceiptIdUsecase getReceiptDetailsByReceiptIdUsecase;
  final GetReceiptDetailsByDeviceCodeUsecase
      getReceiptDetailsByDeviceCodeUsecase;
  final StreamReceiptsDetailsEventUsecae streamReceiptsDetailsEventUsecae;
  late final StreamSubscription<ReceiptDetailsEvent>
      _streamReceiptsDetailsSubscription;
  final ReceiveDevicesUsecase receiveDevicesUsecase;
  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;

  ReceiptDetailsBloc(
      {required this.getReceiptDetailsByReceiptIdUsecase,
      required this.getReceiptDetailsByDeviceCodeUsecase,
      required this.receiveDevicesUsecase,
      required this.streamReceiptsDetailsEventUsecae,
      required this.viewSnackBarMsgUsecase})
      : super(ReceiptDetailsState.initState()) {
    on<GetReceiptDetailsByReceiptId>(_onGetReceiptDetailsByReceiptId);
    on<GetReceiptDetailsByDeviceCode>(_onGetReceiptDetailsByDeviceCode);
    on<ReceiveDevices>(_onReceiveDevices);
    on<RemoveFromDeviceReceiptDetails>(_onRemoveFromDeviceReceiptDetails);
    on<EditDevice>(_onEditDevice);
    streamReceiptsDetailsEventUsecae(Void)
        .then((value) => value.fold((l) => null, (eventStream) {
              _streamReceiptsDetailsSubscription = eventStream.listen((event) {
                this.add(event);
              });
            }));
  }

  FutureOr<void> _onGetReceiptDetailsByReceiptId(
      GetReceiptDetailsByReceiptId event,
      Emitter<ReceiptDetailsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await getReceiptDetailsByReceiptIdUsecase(Params(
      receiptID: event.receiptId,
      receiptDisplayType: event.receiptDisplayType,
    )).then((value) => value.fold((failure) {
          emit(
              ReceiptDetailsErrorState(errorMessage: mapFailureToMsg(failure)));
        }, (receiptDetails) {
          emit(
              state.copyWith(isLoading: false, receiptDetails: receiptDetails));
        }));
  }

  FutureOr<void> _onGetReceiptDetailsByDeviceCode(
      GetReceiptDetailsByDeviceCode event,
      Emitter<ReceiptDetailsState> emit) async {
    print("get receipt page from 'device code : ${event.deviceCode}'");

    emit(state.copyWith(isLoading: true));
    await getReceiptDetailsByDeviceCodeUsecase(ByDeviceCodeParams(
            deviceCode: event.deviceCode,
            receiptDisplayType: event.receiptDisplayType))
        .then((value) => value.fold((failure) {
              emit(ReceiptDetailsErrorState(
                  errorMessage: mapFailureToMsg(failure)));
            }, (receiptDetails) {
              emit(state.copyWith(
                isLoading: false,
                receiptDetails: receiptDetails,
              ));
            }));
  }

  FutureOr<void> _onReceiveDevices(
      ReceiveDevices event, Emitter<ReceiptDetailsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await receiveDevicesUsecase(ReceiveDevicesParam(
      deviceCodes: event.devicesCodes,
      receiptDisplayType: event.receiptDisplayType,
    )).then((result) => result.fold((failure) {
          viewSnackBarMsgUsecase(
              SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
          emit(state.copyWith(isLoading: false));
        }, (r) {
          viewSnackBarMsgUsecase(SnackBarMessageConfig(
              color: AppColors.eucalyptusColor,
              msg: TranslatableValue(translations: {
                "ar": "تم الاستلام بنجاح",
                "en": "Receit received successfully"
              })));
          emit(ReceiptReceivedState(receiptDetails: state.receiptDetails));
        }));
  }

  FutureOr<void> _onRemoveFromDeviceReceiptDetails(
      RemoveFromDeviceReceiptDetails event, Emitter<ReceiptDetailsState> emit) {
    List<DeviceInfo> newDeviceList = state.receiptDetails?.device ?? [];
    newDeviceList.removeWhere((device) => device.id == event.deviceId);
    emit(state.copyWith(
        receiptDetails: state.receiptDetails?.copyWith(device: newDeviceList)));
  }

  FutureOr<void> _onEditDevice(
      EditDevice event, Emitter<ReceiptDetailsState> emit) {
    List<DeviceInfo> deviceList = state.receiptDetails?.device ?? [];
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
        receiptDetails: state.receiptDetails?.copyWith(device: deviceList)));
  }

  @override
  Future<void> close() {
    _streamReceiptsDetailsSubscription.cancel();
    return super.close();
  }
}

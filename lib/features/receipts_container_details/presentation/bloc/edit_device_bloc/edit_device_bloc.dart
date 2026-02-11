import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_api_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_device_res_usecase.dart';

import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/edit_device_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/load_device_details_usecase.dart';

part 'edit_device_event.dart';
part 'edit_device_state.dart';

class EditDeviceBloc extends Bloc<EditDeviceEvent, EditDeviceState> {
  final LoadDeviceDetailsUsecase loadDeviceDetailsUsecase;
  final LoadDeviceResUsecase loadDeviceResUsecase;
  final EditDeviceDetailsUsecase editDeviceDetailsUsecase;
  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;
  final CheckDeviceCodeFromApiUsecase checkDeviceCodeFromApiUsecase;
  Timer? _timer;

  EditDeviceBloc({
    required this.loadDeviceDetailsUsecase,
    required this.loadDeviceResUsecase,
    required this.editDeviceDetailsUsecase,
    required this.viewSnackBarMsgUsecase,
    required this.checkDeviceCodeFromApiUsecase,
  }) : super(EditDeviceState.initial()) {
    on<LoadDeviceDetails>(_onLoadDeviceDetails);

    on<DeviceCodeChanged>(_onDeviceCodeChanged);
    on<SerialNumberChanged>(_onSerialNumberChanged);
    on<BrandChanged>(_onBranchChanged);
    on<ModelChanged>(_onModelChanged);
    on<ItemNameChanged>(_onItemNameChanged);
    on<QtyChanged>(_onQtyChanged);
    on<ProblemDescriptionChanged>(_onProblemDescriptionChanged);
    on<AttachmentsChanged>(_onAttachmentsChanged);
    on<SourceCompanyChanged>(_onSourceCompanyChanged);
    on<WarrantyTypeChanged>(_onWarrantyTypeChanged);
    on<ReasonForWarrantyChanged>(_onReasonForWarrantyChanged);
    on<NewImagesChanged>(_onNewImagesChanged);
    on<RemovedImagesChanged>(_onRemovedImagesChanged);
    on<EditDevice>(_onEditDevice);
    on<UploadProgress>(_onUploadProgress);
    on<CheckDeviceCode>(_onCheckDeviceCode);
    on<_CheckDeviceCodeFromApi>(_onCheckDeviceCodeFromApi);
  }

  FutureOr<void> _onLoadDeviceDetails(
      LoadDeviceDetails event, Emitter<EditDeviceState> emit) async {
    emit(state.copyWith(isLoading: true));

    await loadDeviceResUsecase(NoParams())
        .then((value) => value.fold((failure) {
              final TranslatableValue errorMsg = mapFailureToMsg(failure);
              emit(LoadDeviceDetailsError(errorMessage: errorMsg));
            }, (deviceResources) async {
              await loadDeviceDetailsUsecase(event.deviceId)
                  .then((value) => value.fold((failure) {
                        final TranslatableValue errorMsg =
                            mapFailureToMsg(failure);
                        emit(LoadDeviceDetailsError(errorMessage: errorMsg));
                      }, (deviceDetails) {
                        emit(state.copyWith(
                            companies: deviceResources.companies,
                            deviceTypes: deviceResources.types,
                            deviceDetails: deviceDetails,
                            isLoading: false));
                      }));
            }));
  }

  FutureOr<void> _onCheckDeviceCodeFromApi(
      _CheckDeviceCodeFromApi event, Emitter<EditDeviceState> emit) async {
    await checkDeviceCodeFromApiUsecase(state.deviceDetails!.deviceCode)
        .then((value) => value.fold(
                (l) => emit(state.copyWith(
                      checkDeviceCodeLoading: false,
                      deviceCodeCheckFailed: true,
                    )), (valid) {
              emit(state.copyWith(
                checkDeviceCodeLoading: false,
                deviceCodeTaken: valid,
                deviceCodeCheckFailed: false,
              ));
            }));
  }

  FutureOr<void> _onDeviceCodeChanged(
      DeviceCodeChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        checkDeviceCodeLoading: true,
        deviceDetails:
            state.deviceDetails?.copyWith(deviceCode: event.deviceCode)));

    if (_timer?.isActive ?? false) _timer?.cancel();
    if (state.deviceDetails?.deviceCode.isNotEmpty ?? true) {
      _timer = Timer(Duration(seconds: 1), () {
        add(_CheckDeviceCodeFromApi());
      });
    } else {
      emit(state.copyWith(
        checkDeviceCodeLoading: false,
      ));
    }
  }

  FutureOr<void> _onSerialNumberChanged(
      SerialNumberChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails: state.deviceDetails
            ?.copyWith(deviceSerialNumber: event.serialNumber)));
  }

  FutureOr<void> _onBranchChanged(
      BrandChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails:
            state.deviceDetails?.copyWith(newDeviceType: event.brand)));
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Handles [ModelChanged] event by updating [deviceModel] in [deviceDetails]
  /// in the state.
/******  ddd985cc-aa2c-4c77-9cf6-fa6ecb904ae6  *******/  FutureOr<void> _onModelChanged(
      ModelChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails:
            state.deviceDetails?.copyWith(deviceModel: event.model)));
  }

  FutureOr<void> _onItemNameChanged(
      ItemNameChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails:
            state.deviceDetails?.copyWith(deviceName: event.itemName)));
  }

  FutureOr<void> _onQtyChanged(
      QtyChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails: state.deviceDetails?.copyWith(deviceQty: event.qty)));
  }

  FutureOr<void> _onProblemDescriptionChanged(
      ProblemDescriptionChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails: state.deviceDetails
            ?.copyWith(problemDescription: event.problemDescription)));
  }

  FutureOr<void> _onAttachmentsChanged(
      AttachmentsChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails: state.deviceDetails
            ?.copyWith(deviceAttachments: event.attachments)));
  }

  FutureOr<void> _onSourceCompanyChanged(
      SourceCompanyChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails:
            state.deviceDetails?.copyWith(company: event.sourceCompany)));
  }

  FutureOr<void> _onWarrantyTypeChanged(
      WarrantyTypeChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails:
            state.deviceDetails?.copyWith(deviceWarranty: event.warrantyType)));
  }

  FutureOr<void> _onReasonForWarrantyChanged(
      ReasonForWarrantyChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails: state.deviceDetails
            ?.copyWith(warrantyReason: event.reasonForWarranty)));
  }

  FutureOr<void> _onNewImagesChanged(
      NewImagesChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(
        deviceDetails:
            state.deviceDetails?.copyWith(fileImages: List.of(event.images))));
  }

  FutureOr<void> _onRemovedImagesChanged(
      RemovedImagesChanged event, Emitter<EditDeviceState> emit) {
    List<String> deletedImages = state.deviceDetails!.deletedImages!;
    deletedImages.add(event.image);

    emit(state.copyWith(
        deviceDetails: state.deviceDetails
            ?.copyWith(deletedImages: List.of(deletedImages))));
  }

  FutureOr<void> _onEditDevice(
      EditDevice event, Emitter<EditDeviceState> emit) async {
    emit(state.copyWith(editLoading: true));

    await editDeviceDetailsUsecase(DeviceDetailsParams(
        deviceId: event.deviceId,
        deviceDetails: state.deviceDetails!,
        onSendProgress: (progress, total) {
          this.add(UploadProgress(progress: progress / total));
        })).then((value) => value.fold((failure) {
          viewSnackBarMsgUsecase(
              SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
          emit(state.copyWith(editLoading: false));
        }, (r) {
          viewSnackBarMsgUsecase(SnackBarMessageConfig(
              color: AppColors.eucalyptusColor,
              msg: TranslatableValue.fromTranslations(
                  translations: Translation(
                      en: "The device has been modified",
                      ar: "تم تعديل الجهاز"))));
          emit(state.copyWith(editCompleted: true, editLoading: false));
        }));
  }

  FutureOr<void> _onUploadProgress(
      UploadProgress event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(uploadProgress: event.progress));
  }

  FutureOr<void> _onCheckDeviceCode(
      CheckDeviceCode event, Emitter<EditDeviceState> emit) async {
    emit(state.copyWith(
        checkDeviceCodeLoading: true,
        // deviceCodeCheckFailed: false,
        deviceCodeTaken: false));
    await checkDeviceCodeFromApiUsecase(state.deviceDetails!.deviceCode)
        .then((value) => value.fold(
              (l) => emit(state.copyWith(
                  checkDeviceCodeLoading: false,
                  deviceCodeCheckFailed: true,
                  deviceCodeTaken: false)),
              (found) {
                emit(state.copyWith(
                    checkDeviceCodeLoading: false,
                    deviceCodeTaken: found,
                    deviceCodeCheckFailed: false));
              },
            ));
  }
}

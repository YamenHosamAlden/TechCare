import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_api_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_device_res_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_collection_usecase.dart';

part 'add_device_event.dart';
part 'add_device_state.dart';

class AddDeviceBloc extends Bloc<AddDeviceEvent, AddDeviceState> {
  final LoadDeviceResUsecase loadDeviceResUsecase;
  final CheckDeviceCodeUsecaseFromCollection
      checkDeviceCodeUsecaseFromCollection;
  final CheckDeviceCodeFromApiUsecase checkDeviceCodeFromApiUsecase;
  Timer? _timer;

  AddDeviceBloc(
      {required this.loadDeviceResUsecase,
      required this.checkDeviceCodeFromApiUsecase,
      required this.checkDeviceCodeUsecaseFromCollection,
      Device? device,
      List<Collection>? collectionList})
      : super(AddDeviceState.initial(
          device: device,
          collectionList: collectionList,
        )) {
    on<LoadRequiredResources>(_onLoadRequiredResources);
    on<DeviceCodeChanged>(_onDeviceCodeChanged);
    on<SerialNumberChanged>(_onSerialNumberChanged);
    on<BrandChanged>(_onBrandChanged);
    on<ModelChanged>(_onModelChanged);
    on<ItemNameChanged>(_onItemNameChanged);
    on<QtyChanged>(_onQtyChanged);
    on<ProblemDescriptionChanged>(_onProblemDescriptionChanged);
    on<AttachmentsChanged>(_onAttachmentsChanged);
    on<SourceCompanyChanged>(_onSourceCompanyChanged);
    on<WarrantyTypeChanged>(_onWarrantyTypeChanged);
    on<ReasonForWarrantyChanged>(_onReasonForWarrantyChanged);
    on<ImagesChanged>(_onImagesCahnged);
    on<CheckDeviceCode>(_onCheckDeviceCode);
    on<_CheckDeviceCodeFromCollection>(_onCheckDeviceCodeFromCollection);
    on<_CheckDeviceCodeFromApi>(_onCheckDeviceCodeFromApi);
    on<SubmitDeviceEvent>(_onSubmitDeviceEvent);
  }

  FutureOr<void> _onLoadRequiredResources(
      LoadRequiredResources event, Emitter<AddDeviceState> emit) async {
    emit(state.copyWith(removeErrorStateMsg: true, isLoading: true));
    await loadDeviceResUsecase(NoParams())
        .then((value) => value.fold((failure) {
              final TranslatableValue errorMsg = mapFailureToMsg(failure);
              emit(state.copyWith(isLoading: false, errorStateMsg: errorMsg));
            }, (res) {
              emit(state.copyWith(
                isLoading: false,
                companies: res.companies,
                deviceTypes: res.types,
              ));
            }));
  }

  FutureOr<void> _onCheckDeviceCode(
      CheckDeviceCode event, Emitter<AddDeviceState> emit) async {
    emit(state.copyWith(
        checkDeviceCodeLoading: true,
        deviceCheckCounter: state.deviceCheckCounter + 1));

    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      if (state.device.deviceCode?.isEmpty ?? true)
        emit(state.copyWith(checkDeviceCodeLoading: false));
    }

    if (state.device.deviceCode?.isNotEmpty ?? true) {
      _timer = Timer(Duration(seconds: 1), () {
        add(_CheckDeviceCodeFromApi());
      });
    } else {
      emit(state.copyWith(checkDeviceCodeLoading: false));
    }
  }

  FutureOr<void> _onCheckDeviceCodeFromApi(
      _CheckDeviceCodeFromApi event, Emitter<AddDeviceState> emit) async {
    int currentDeviceCheckCounter = state.deviceCheckCounter;

    await checkDeviceCodeFromApiUsecase(state.device.deviceCode!).then((value) {
      if (currentDeviceCheckCounter == state.deviceCheckCounter) {
        value.fold(
          (l) {
            emit(state.copyWith(
              checkDeviceCodeLoading: false,
              deviceCodeCheckFailed: true,
            ));
          },
          (valid) {
            if (valid) {
              emit(state.copyWith(
                deviceCodeCheckFailed: false,
                checkDeviceCodeLoading: false,
                deviceCodeTaken: valid,
              ));
            } else {
              add(_CheckDeviceCodeFromCollection());
            }
          },
        );
      }
    });
  }

  FutureOr<void> _onCheckDeviceCodeFromCollection(
      _CheckDeviceCodeFromCollection event,
      Emitter<AddDeviceState> emit) async {
    await checkDeviceCodeUsecaseFromCollection(CheckDeviceCodeParams(
      deviceCode: state.device.deviceCode!,
      collectionList: state.collectionList!,
      codeFromEdit: state.codeFromEdit,
    )).then((value) => value.fold(
          (l) => null,
          (valid) {
            emit(state.copyWith(
              deviceCodeCheckFailed: false,
              checkDeviceCodeLoading: false,
              deviceCodeTaken: valid,
            ));
          },
        ));
  }

  FutureOr<void> _onDeviceCodeChanged(
      DeviceCodeChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device.copyWith(deviceCode: event.deviceCode)));

    add(CheckDeviceCode());
  }

  FutureOr<void> _onSerialNumberChanged(
      SerialNumberChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device.copyWith(serialNumber: event.serialNumber)));
  }

  FutureOr<void> _onBrandChanged(
      BrandChanged event, Emitter<AddDeviceState> emit) {
    emit(
      state.copyWith(
        device: state.device.copyWith(brand: event.brand),
      ),
    );
  }

  FutureOr<void> _onModelChanged(
      ModelChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(device: state.device.copyWith(model: event.model)));
  }

  FutureOr<void> _onItemNameChanged(
      ItemNameChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device.copyWith(itemName: event.itemName)));
  }

  FutureOr<void> _onQtyChanged(QtyChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(device: state.device.copyWith(qty: event.qty)));
  }

  FutureOr<void> _onProblemDescriptionChanged(
      ProblemDescriptionChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device
            .copyWith(problemDescription: event.problemDescription)));
  }

  FutureOr<void> _onAttachmentsChanged(
      AttachmentsChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device.copyWith(attachments: event.attachments)));
  }

  FutureOr<void> _onSourceCompanyChanged(
      SourceCompanyChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device.copyWith(sourceCompany: event.sourceCompany)));
  }

  FutureOr<void> _onWarrantyTypeChanged(
      WarrantyTypeChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device.copyWith(warrantyType: event.warrantyType)));
  }

  FutureOr<void> _onReasonForWarrantyChanged(
      ReasonForWarrantyChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device:
            state.device.copyWith(reasonForWarranty: event.reasonForWarranty)));
  }

  FutureOr<void> _onImagesCahnged(
      ImagesChanged event, Emitter<AddDeviceState> emit) {
    emit(state.copyWith(
        device: state.device.copyWith(images: List.of(event.images))));
  }

  FutureOr<void> _onSubmitDeviceEvent(
      SubmitDeviceEvent event, Emitter<AddDeviceState> emit) {
    emit(DeviceSubmitted(device: state.device.copyWith()));
  }
}

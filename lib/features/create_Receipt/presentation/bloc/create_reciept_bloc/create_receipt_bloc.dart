import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/employee.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/maintenance_group.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/create_receipt_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_create_receipt_res_usecase.dart';
part 'create_receipt_event.dart';
part 'create_receipt_state.dart';

class CreateReceiptBloc extends Bloc<CreateReceiptEvent, CreateReceiptState> {
  final CreateReceiptUsecase createReceiptUsecase;
  final LoadCreateReceiptResUsecase loadCreateReceiptResUsecase;
  CreateReceiptBloc({
    required this.createReceiptUsecase,
    required this.loadCreateReceiptResUsecase,
  }) : super(CreateReceiptState.initial()) {
    on<LoadPageResources>(_onLoadPageResources);
    on<CustomerNameChanged>(_onCustomerNameChanged);
    on<CustomerPhoneChanged>(_onCustomerPhoneChanged);
    on<PriorityChanged>(_onPriorityChanged);
    on<ShippingNumberChanged>(_onShippingNumberChanged);
    on<SelectCollectionGroup>(_onSelectCollectionGroup);
    on<SelectCollectionEmployee>(_onSelectCollectionEmployee);
    on<AddCollectionEvent>(_onAddCollectionEvent);
    on<DeleteCollectionEvent>(_onDeleteCollectionEvent);
    on<AddDeviceToCollection>(_onAddDeviceToCollection);
    on<EditDevice>(_onEditDevice);
    on<DeleteDevice>(_onDeleteDevice);
    on<NewReceiptSubmitted>(_onCreateReceiptEvent);
    on<_UploadProgress>(_onUploadProgress);
    on<CountryCodeChanged>(_onCountryCodeChanged);
  }

  FutureOr<void> _onLoadPageResources(
      LoadPageResources event, Emitter<CreateReceiptState> emit) async {
    emit(state.copyWith(isPageLoading: true));
    await loadCreateReceiptResUsecase(NoParams()).then((value) =>
        value.fold((failure) {
          final TranslatableValue errorMsg = mapFailureToMsg(failure);
          emit(state.copyWith(isPageLoading: false, errorStateMsg: errorMsg));
        }, (maintenanceGroups) {
          emit(state.copyWith(
              isPageLoading: false, maintenanceGroups: maintenanceGroups));
        }));
  }

  FutureOr<void> _onCustomerNameChanged(
      CustomerNameChanged event, Emitter<CreateReceiptState> emit) {
    emit(state.copyWith(customerName: event.customerName));
  }

  FutureOr<void> _onCustomerPhoneChanged(
      CustomerPhoneChanged event, Emitter<CreateReceiptState> emit) {
    emit(state.copyWith(customerPhone: event.customerPhone));
  }

  FutureOr<void> _onPriorityChanged(
      PriorityChanged event, Emitter<CreateReceiptState> emit) {
    emit(state.copyWith(priority: event.priority, shippingNumber: ''));
  }

  FutureOr<void> _onShippingNumberChanged(
      ShippingNumberChanged event, Emitter<CreateReceiptState> emit) {
    emit(state.copyWith(shippingNumber: event.shippingNumber));
  }

  FutureOr<void> _onSelectCollectionGroup(
      SelectCollectionGroup event, Emitter<CreateReceiptState> emit) {
    final _collections = List.of(state.collections);

    final Collection newCollection = _collections
        .elementAt(event.collectionIndex)
        .copyWith(group: event.maintenanceGroup, setEmployeeNull: true);
    _collections.removeAt(event.collectionIndex);
    _collections.insert(event.collectionIndex, newCollection);
    emit(state.copyWith(collections: _collections));
  }

  FutureOr<void> _onSelectCollectionEmployee(
      SelectCollectionEmployee event, Emitter<CreateReceiptState> emit) {
    final _collections = List.of(state.collections);
    final Collection newCollection = _collections
        .elementAt(event.collectionIndex)
        .copyWith(employee: event.employee);
    _collections.removeAt(event.collectionIndex);
    _collections.insert(event.collectionIndex, newCollection);
    emit(state.copyWith(collections: _collections));
  }

  FutureOr<void> _onAddCollectionEvent(
      AddCollectionEvent event, Emitter<CreateReceiptState> emit) {
    final _collections = List<Collection>.from(state.collections);
    _collections.add(Collection(devices: []));

    emit(state.copyWith(collections: _collections));
  }

  FutureOr<void> _onAddDeviceToCollection(
      AddDeviceToCollection event, Emitter<CreateReceiptState> emit) {
    print(event.device.deviceCode);
    final List<Collection> updatedCollections = state.collections
        .map((collection) =>
            collection.copyWith(devices: List<Device>.from(collection.devices)))
        .toList();
    updatedCollections[event.collectionIndex].devices.add(event.device);
    emit(state.copyWith(collections: updatedCollections));
  }

  FutureOr<void> _onDeleteDevice(
      DeleteDevice event, Emitter<CreateReceiptState> emit) {
    final List<Collection> updatedCollections = state.collections
        .map((collection) =>
            collection.copyWith(devices: List<Device>.from(collection.devices)))
        .toList();
    updatedCollections
        .elementAt(event.collectionIndex)
        .devices
        .removeAt(event.deviceIndex);
    emit(state.copyWith(collections: updatedCollections));
  }

  FutureOr<void> _onDeleteCollectionEvent(
      DeleteCollectionEvent event, Emitter<CreateReceiptState> emit) {
    final _collections = List<Collection>.from(state.collections)
      ..removeAt(event.elementIndex);

    emit(state.copyWith(
      collections: _collections,
    ));
  }

  FutureOr<void> _onEditDevice(
      EditDevice event, Emitter<CreateReceiptState> emit) {
    final List<Collection> updatedCollections = state.collections
        .map((collection) =>
            collection.copyWith(devices: List<Device>.from(collection.devices)))
        .toList();
    updatedCollections[event.collectionIndex].devices[event.deviceIndex] =
        event.device;
    emit(state.copyWith(collections: updatedCollections));
  }

  FutureOr<void> _onCreateReceiptEvent(
      NewReceiptSubmitted event, Emitter<CreateReceiptState> emit) async {
    emit(state.copyWith(isLoading: true, removeProgress: true));
    await createReceiptUsecase(
      Params(
          customerName: state.customerName!,
          customerPhone: _phoneNumberWithCountryCode(state.customerPhone!),
          priority: state.priority!,
          shippingNumber: state.shippingNumber,
          collections: state.collections,
          onSendProgress: (progress, total) {
            this.add(_UploadProgress(progress: progress / total));
          }),
    ).then((value) => value.fold((failure) {
          final TranslatableValue errorMsg = mapFailureToMsg(failure);
          emit(state.copyWith(isLoading: false, errorMsg: errorMsg));
          print(failure);
        }, (receiptUrl) {
          emit(state.copyWith(isLoading: false, removeProgress: true));
          emit(ReceiptCreated(receiptUrl: receiptUrl));
        }));
  }

  FutureOr<void> _onUploadProgress(
      _UploadProgress event, Emitter<CreateReceiptState> emit) {
    emit(state.copyWith(uploadProgress: event.progress));
  }

  FutureOr<void> _onCountryCodeChanged(
      CountryCodeChanged event, Emitter<CreateReceiptState> emit) {
    emit(state.copyWith(countryCode: event.countryCode));
  }

  String _phoneNumberWithCountryCode(String phone) {
    return state.countryCode + (phone[0] == '0' ? phone.substring(1) : phone);
  }
}

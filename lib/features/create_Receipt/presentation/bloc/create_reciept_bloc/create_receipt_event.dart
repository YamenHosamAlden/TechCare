part of 'create_receipt_bloc.dart';

sealed class CreateReceiptEvent extends Equatable {
  const CreateReceiptEvent();

  @override
  List<Object> get props => [];
}

final class LoadPageResources extends CreateReceiptEvent {}

final class CustomerNameChanged extends CreateReceiptEvent {
  final String customerName;
  CustomerNameChanged({required this.customerName});
}

final class CustomerPhoneChanged extends CreateReceiptEvent {
  final String customerPhone;
  CustomerPhoneChanged({required this.customerPhone});
}

final class PriorityChanged extends CreateReceiptEvent {
  final TranslatableValue priority;
  PriorityChanged({required this.priority});
}

final class ShippingNumberChanged extends CreateReceiptEvent {
  final String shippingNumber;
  ShippingNumberChanged({required this.shippingNumber});
}

final class SelectCollectionGroup extends CreateReceiptEvent {
  final int collectionIndex;
  final MaintenanceGroup maintenanceGroup;
  SelectCollectionGroup(
      {required this.collectionIndex, required this.maintenanceGroup});
}

final class SelectCollectionEmployee extends CreateReceiptEvent {
  final int collectionIndex;
  final Employee employee;
  SelectCollectionEmployee(
      {required this.collectionIndex, required this.employee});
}

final class AddDeviceToCollection extends CreateReceiptEvent {
  final int collectionIndex;
  final Device device;
  AddDeviceToCollection({required this.collectionIndex, required this.device});
}

final class EditDevice extends CreateReceiptEvent {
  final int collectionIndex;
  final int deviceIndex;
  final Device device;
  EditDevice(
      {required this.collectionIndex,
      required this.deviceIndex,
      required this.device});
}

final class DeleteDevice extends CreateReceiptEvent {
  final int collectionIndex;
  final int deviceIndex;
  DeleteDevice({required this.collectionIndex, required this.deviceIndex});
}

final class AddCollectionEvent extends CreateReceiptEvent {}

final class DeleteCollectionEvent extends CreateReceiptEvent {
  final int elementIndex;
  DeleteCollectionEvent({required this.elementIndex});
}

final class NewReceiptSubmitted extends CreateReceiptEvent {}

final class _UploadProgress extends CreateReceiptEvent {
  final double progress;

  _UploadProgress({required this.progress});
}

final class CountryCodeChanged extends CreateReceiptEvent{
  final String countryCode;
 const  CountryCodeChanged({required this.countryCode});
}
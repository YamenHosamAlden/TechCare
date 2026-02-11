part of 'add_device_bloc.dart';

sealed class AddDeviceEvent extends Equatable {
  const AddDeviceEvent();

  @override
  List<Object> get props => [];
}

class LoadRequiredResources extends AddDeviceEvent {}

class DeviceCodeChanged extends AddDeviceEvent {
  final String deviceCode;

  DeviceCodeChanged({required this.deviceCode});
}

class SerialNumberChanged extends AddDeviceEvent {
  final String serialNumber;

  SerialNumberChanged({required this.serialNumber});
}

class BrandChanged extends AddDeviceEvent {
  final String brand;

  BrandChanged({required this.brand});
}

class ModelChanged extends AddDeviceEvent {
  final String model;

  ModelChanged({required this.model});
}

class ItemNameChanged extends AddDeviceEvent {
  final String itemName;

  ItemNameChanged({required this.itemName});
}

class QtyChanged extends AddDeviceEvent {
  final String qty;

  QtyChanged({required this.qty});
}

class ProblemDescriptionChanged extends AddDeviceEvent {
  final String problemDescription;

  ProblemDescriptionChanged({required this.problemDescription});
}

class AttachmentsChanged extends AddDeviceEvent {
  final String attachments;

  AttachmentsChanged({required this.attachments});
}

class SourceCompanyChanged extends AddDeviceEvent {
  final Company sourceCompany;

  SourceCompanyChanged({required this.sourceCompany});
}

class WarrantyTypeChanged extends AddDeviceEvent {
  final TranslatableValue warrantyType;

  WarrantyTypeChanged({required this.warrantyType});
}

class ReasonForWarrantyChanged extends AddDeviceEvent {
  final String reasonForWarranty;

  ReasonForWarrantyChanged({required this.reasonForWarranty});
}

class ImagesChanged extends AddDeviceEvent {
  final List<File> images;

  ImagesChanged({required this.images});
}

class SubmitDeviceEvent extends AddDeviceEvent {}


class CheckDeviceCode extends AddDeviceEvent {}
class _CheckDeviceCodeFromCollection extends AddDeviceEvent {}
class _CheckDeviceCodeFromApi extends AddDeviceEvent {}

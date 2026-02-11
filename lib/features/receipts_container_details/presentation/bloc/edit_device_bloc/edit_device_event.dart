// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_device_bloc.dart';

sealed class EditDeviceEvent extends Equatable {
  const EditDeviceEvent();

  @override
  List<Object> get props => [];
}

class LoadDeviceDetails extends EditDeviceEvent {
  final int deviceId;

  LoadDeviceDetails({required this.deviceId});
}

class DeviceCodeChanged extends EditDeviceEvent {
  final String deviceCode;

  DeviceCodeChanged({required this.deviceCode});
}

class SerialNumberChanged extends EditDeviceEvent {
  final String serialNumber;

  SerialNumberChanged({required this.serialNumber});
}

// class TypeChanged extends EditDeviceEvent {
//   final DeviceType type;

//   TypeChanged({required this.type});
// }

class BrandChanged extends EditDeviceEvent {
  final String brand;

  BrandChanged({required this.brand});
}

class ModelChanged extends EditDeviceEvent {
  final String model;

  ModelChanged({required this.model});
}

class ItemNameChanged extends EditDeviceEvent {
  final String itemName;

  ItemNameChanged({required this.itemName});
}

class QtyChanged extends EditDeviceEvent {
  final String qty;

  QtyChanged({required this.qty});
}

class ProblemDescriptionChanged extends EditDeviceEvent {
  final String problemDescription;

  ProblemDescriptionChanged({required this.problemDescription});
}

class AttachmentsChanged extends EditDeviceEvent {
  final String attachments;

  AttachmentsChanged({required this.attachments});
}

class SourceCompanyChanged extends EditDeviceEvent {
  final Company sourceCompany;

  SourceCompanyChanged({required this.sourceCompany});
}

class WarrantyTypeChanged extends EditDeviceEvent {
  final TranslatableValue warrantyType;

  WarrantyTypeChanged({required this.warrantyType});
}

class ReasonForWarrantyChanged extends EditDeviceEvent {
  final String reasonForWarranty;

  ReasonForWarrantyChanged({required this.reasonForWarranty});
}

class NewImagesChanged extends EditDeviceEvent {
  final List<File> images;

  NewImagesChanged({required this.images});
}

class RemovedImagesChanged extends EditDeviceEvent {
  final String image;

  RemovedImagesChanged({required this.image});
}

class EditDevice extends EditDeviceEvent {
  final int deviceId;
  EditDevice({
    required this.deviceId,
  });
}

class UploadProgress extends EditDeviceEvent {
  final double progress;

  UploadProgress({required this.progress});
}

class CheckDeviceCode extends EditDeviceEvent {}

class _CheckDeviceCodeFromApi extends EditDeviceEvent {}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'receipts_container_details_bloc.dart';

abstract class ReceiptsContainerDetailsEvent extends Equatable {
  const ReceiptsContainerDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadContainerDetails extends ReceiptsContainerDetailsEvent {
  final int containerId;
  final ContainerDisplayType displayType;

  LoadContainerDetails({
    required this.containerId,
    required this.displayType,
  });
}

class RemoveFromDeviceList extends ReceiptsContainerDetailsEvent {
  final int deviceId;
  RemoveFromDeviceList({
    required this.deviceId,
  });
}

final class EditDevice extends ReceiptsContainerDetailsEvent {
  final int deviceId;

  final DeviceInfo deviceInfo;

  EditDevice({
    required this.deviceId,
    required this.deviceInfo,
  });
}

final class EditReceipt extends ReceiptsContainerDetailsEvent {
  final ContainerDetails containerDetails;

  EditReceipt({
    required this.containerDetails,
  });
}

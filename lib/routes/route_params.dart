import 'package:tech_care_app/features/create_receipt/domain/entities/device.dart';
import 'package:tech_care_app/features/create_receipt/presentation/bloc/create_reciept_bloc/create_receipt_bloc.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';

sealed class RouteParams extends Object {}

final class AddDeviceParams extends RouteParams {
  final Device? device;
  final int? deviceIndex;
  final int collectionIndex;
  final CreateReceiptBloc createReceiptBloc;

  AddDeviceParams(
      {this.device,
      this.deviceIndex,
      required this.collectionIndex,
      required this.createReceiptBloc})
      : assert((device == null && deviceIndex == null) ||
            (device != null && deviceIndex != null));
}

final class ReceiptDetailsParams extends RouteParams {
  final int? receiptID;
  final String? deviceCode;
  final ReceiptDisplayType receiptDisplayType;

  ReceiptDetailsParams({
    this.receiptID,
    this.deviceCode,
    this.receiptDisplayType = ReceiptDisplayType.display,
  })  : assert(deviceCode == null || receiptID == null,
            "You must pass the device code or the receipt ID"),
        assert(
            (deviceCode == null && receiptID != null) ||
                (deviceCode != null && receiptID == null),
            "You must pass the device code or the receipt ID,but not both together.");
}

final class DeviceDetailsParams extends RouteParams {
  final int? deviceID;
  final String? deviceCode;

  DeviceDetailsParams({
    this.deviceID,
    this.deviceCode,
  })  : assert(deviceCode == null || deviceID == null,
            "You must pass the device code or the device ID."),
        assert(
            (deviceCode == null && deviceID != null) ||
                (deviceCode != null && deviceID == null),
            "You must pass the device code or the device ID,but not both together.");
}

final class QualityReportParams extends RouteParams {
  final int deviceID;
  final String customerPhone;

  QualityReportParams({required this.deviceID, required this.customerPhone});
}

final class ContainerDetailsParams extends RouteParams {
  final int containerId;
  final ContainerDisplayType type;

  ContainerDetailsParams({required this.containerId, required this.type});
}

final class ReceiptContainerDetailsParams extends RouteParams {
  final ContainerDetails containerDetails;

  ReceiptContainerDetailsParams({required this.containerDetails});
}

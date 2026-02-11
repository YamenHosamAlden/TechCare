part of 'receipt_details_bloc.dart';

sealed class ReceiptDetailsEvent extends Equatable {
  const ReceiptDetailsEvent();

  @override
  List<Object> get props => [];
}

final class GetReceiptDetailsByReceiptId extends ReceiptDetailsEvent {
  final int receiptId;
  final ReceiptDisplayType receiptDisplayType;
  GetReceiptDetailsByReceiptId({
    required this.receiptId,
    required this.receiptDisplayType,
  });
}

final class GetReceiptDetailsByDeviceCode extends ReceiptDetailsEvent {
  final String deviceCode;
  final ReceiptDisplayType receiptDisplayType;

  GetReceiptDetailsByDeviceCode({
    required this.deviceCode,
    required this.receiptDisplayType,
  });
}

final class ReceiveDevices extends ReceiptDetailsEvent {
  final ReceiptDisplayType receiptDisplayType;
  final List<String> devicesCodes;

  ReceiveDevices({
    required this.devicesCodes,
    required this.receiptDisplayType,
  });
}

final class RemoveFromDeviceReceiptDetails extends ReceiptDetailsEvent {
  final int deviceId;

  RemoveFromDeviceReceiptDetails({required this.deviceId});
}

final class EditDevice extends ReceiptDetailsEvent {
  final int deviceId;

  final DeviceInfo deviceInfo;

  EditDevice({
    required this.deviceId,
    required this.deviceInfo,
  });
}

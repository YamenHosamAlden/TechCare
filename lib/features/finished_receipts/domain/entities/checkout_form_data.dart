import 'package:equatable/equatable.dart';

class CheckoutFormData extends Equatable {
  final List<DeviceAmountReceived> amounts;
  final num totalAmount;
  final String note;

  CheckoutFormData({
    required this.amounts,
    required this.totalAmount,
    required this.note,
  });

  CheckoutFormData copyWith(
      {List<DeviceAmountReceived>? amounts, num? totalAmount, String? note}) {
    return CheckoutFormData(
      amounts: amounts ?? this.amounts,
      totalAmount: totalAmount ?? this.totalAmount,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [amounts, totalAmount, note];
}

class DeviceAmountReceived extends Equatable {
  final int deviceId;
  final String deviceCode;
  final num amount;

  const DeviceAmountReceived({
    required this.deviceId,
    required this.deviceCode,
    required this.amount,
  });

  DeviceAmountReceived copyWith(
          {int? deviceId, String? deviceCode, num? amount, num? totalAmount}) =>
      DeviceAmountReceived(
        deviceId: deviceId ?? this.deviceId,
        deviceCode: deviceCode ?? this.deviceCode,
        amount: amount ?? this.amount,
      );

  @override
  List<Object?> get props => [
        deviceId,
        deviceCode,
        amount,
      ];
}

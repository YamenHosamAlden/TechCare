import 'package:tech_care_app/features/finished_receipts/domain/entities/checkout_form_data.dart';

class CheckoutFormDataModel extends CheckoutFormData {
  final List<DeviceAmountReceivedModel> amounts;
  CheckoutFormDataModel({
    required super.totalAmount,
    required super.note,
    required this.amounts,
  }) : super(amounts: amounts);

  CheckoutFormDataModel.fromEntity(CheckoutFormData checkoutFormData)
      : this(
          amounts: checkoutFormData.amounts
              .map(DeviceAmountReceivedModel.fromEntity)
              .toList(),
          note: checkoutFormData.note,
          totalAmount: checkoutFormData.totalAmount,
        );
}

class DeviceAmountReceivedModel extends DeviceAmountReceived {
  DeviceAmountReceivedModel({
    required super.deviceId,
    required super.deviceCode,
    required super.amount,
  });

  DeviceAmountReceivedModel.fromEntity(
      DeviceAmountReceived deviceAmountReceived)
      : this(
          amount: deviceAmountReceived.amount,
          deviceCode: deviceAmountReceived.deviceCode,
          deviceId: deviceAmountReceived.deviceId,
        );

  Map<String, dynamic> toJson() => {
        "id": deviceId,
        "value": amount,
      };
}

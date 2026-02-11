part of 'edit_receipt_bloc.dart';

abstract class EditReceiptEvent extends Equatable {
  const EditReceiptEvent();

  @override
  List<Object> get props => [];
}

class EditReceiptDetailsEvent extends EditReceiptEvent {
  final ContainerDetails containerDetails;
  const EditReceiptDetailsEvent({required this.containerDetails});
}

final class CustomerNameChanged extends EditReceiptEvent {
  final String customerName;
  CustomerNameChanged({required this.customerName});
}

final class CustomerPhoneChanged extends EditReceiptEvent {
  final String customerPhone;
  CustomerPhoneChanged({required this.customerPhone});
}

final class PriorityChanged extends EditReceiptEvent {
  final TranslatableValue priority;
  PriorityChanged({required this.priority});
}

final class ShippingNumberChanged extends EditReceiptEvent {
  final String shippingNumber;
  ShippingNumberChanged({required this.shippingNumber});
}


 class UploadProgress extends EditReceiptEvent {
  final double progress;

  UploadProgress({required this.progress});
}

final class CountryCodeChanged extends EditReceiptEvent{
  final String countryCode;
 const  CountryCodeChanged({required this.countryCode});
}
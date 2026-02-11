part of 'finishing_report_bloc.dart';

sealed class FinishingReportEvent extends Equatable {
  const FinishingReportEvent();

  @override
  List<Object> get props => [];
}

final class GetFinishingReport extends FinishingReportEvent {
  final int containerId;
  GetFinishingReport({required this.containerId});
}

final class Checkout extends FinishingReportEvent {
  // final num amount;
  final String note;
  Checkout({required this.note});
}

final class UpdateDeviceAmountReceived extends FinishingReportEvent {
  final int deviceId;
  final num amount;
  UpdateDeviceAmountReceived({required this.deviceId, required this.amount});
}

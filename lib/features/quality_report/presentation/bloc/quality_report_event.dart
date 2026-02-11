part of 'quality_report_bloc.dart';

abstract class QualityReportEvent extends Equatable {
  const QualityReportEvent();

  @override
  List<Object> get props => [];
}

final class LoadQualityReportFeed extends QualityReportEvent {
  final int deviceId;
  LoadQualityReportFeed({required this.deviceId});
}

final class ChangeAcceptanceStatus extends QualityReportEvent {
  final bool acceptanceStatus;
  ChangeAcceptanceStatus({required this.acceptanceStatus});
}

final class SalesReturnStatusChanged extends QualityReportEvent {
  final bool isSalesReturn;
  SalesReturnStatusChanged({required this.isSalesReturn});
}

final class CustomerNotified extends QualityReportEvent {
  final bool isNotified;
  CustomerNotified({required this.isNotified});
}

final class ReturnToGroup extends QualityReportEvent {
  final bool isReturnToGroup;
  ReturnToGroup({required this.isReturnToGroup});
}

final class SelectUser extends QualityReportEvent {
  final GroupUser user;
  SelectUser({required this.user});
}

final class SubmitQualityReport extends QualityReportEvent {
  final int deviceId;
  final String report;
  final String fixedCost;
  final String testDuration;

  SubmitQualityReport({
    required this.deviceId,
    required this.report,
    required this.fixedCost,
    required this.testDuration,
  });
}

final class SubmitExternalItems extends QualityReportEvent {
  final int deviceId;
  final List<ExternalItem> pricedExternalItems;
  SubmitExternalItems({
    required this.deviceId,
    required this.pricedExternalItems,
  });
}

final class LoadMaintenanceSummary extends QualityReportEvent {
  final int deviceId;

  LoadMaintenanceSummary({
    required this.deviceId,
  });
}

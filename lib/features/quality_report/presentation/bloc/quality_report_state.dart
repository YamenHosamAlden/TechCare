part of 'quality_report_bloc.dart';

final class QualityReportState extends Equatable {
  final QualityReportFeed? feed;
  final MaintenanceSummary? maintenanceSummary;
  final bool acceptanceStatus;
  final bool salesReturn;
  final bool customerNotified;
  final bool returnToGroup;
  final GroupUser? selectedUser;
  final bool pageLoading;
  final bool submittingReport;
  final bool submittingExternalItems;
  final bool? reportSubmitted;
  final bool loadingsummary;
  final bool summaryErrorState;
  final bool externalItemsPricingCompleted;
  final TranslatableValue? errorMsg;

  const QualityReportState.initial()
      : this(pageLoading: true, acceptanceStatus: true);

  const QualityReportState({
    required this.pageLoading,
    required this.acceptanceStatus,
    this.returnToGroup = false,
    this.salesReturn = false,
    this.customerNotified = false,
    this.selectedUser,
    this.feed,
    this.maintenanceSummary,
    this.submittingReport = false,
    this.submittingExternalItems = false,
    this.reportSubmitted,
    this.loadingsummary = false,
    this.summaryErrorState = false,
    this.externalItemsPricingCompleted = false,
    this.errorMsg,
  });

  QualityReportState copyWith({
    bool? pageLoading,
    bool? acceptanceStatus,
    bool? returnToGroup,
    bool? salesReturn,
    bool? customerNotified,
    GroupUser? selectedUser,
    bool removeSelectedUser = false,
    QualityReportFeed? feed,
    MaintenanceSummary? maintenanceSummary,
    bool? submittingReport,
    bool? submittingExternalItems,
    bool? reportSubmitted,
    bool? loadingsummary,
    bool? summaryErrorState,
    bool? externalItemsPricingCompleted,
    TranslatableValue? errorMsg,
  }) =>
      QualityReportState(
        pageLoading: pageLoading ?? this.pageLoading,
        acceptanceStatus: acceptanceStatus ?? this.acceptanceStatus,
        returnToGroup: returnToGroup ?? this.returnToGroup,
        salesReturn: salesReturn ?? this.salesReturn,
        customerNotified: customerNotified ?? this.customerNotified,
        selectedUser:
            removeSelectedUser ? null : selectedUser ?? this.selectedUser,
        feed: feed ?? this.feed,
        maintenanceSummary: maintenanceSummary ?? this.maintenanceSummary,
        submittingReport: submittingReport ?? this.submittingReport,
        submittingExternalItems:
            submittingExternalItems ?? this.submittingExternalItems,
        reportSubmitted: reportSubmitted ?? this.reportSubmitted,
        loadingsummary: loadingsummary ?? this.loadingsummary,
        summaryErrorState: summaryErrorState ?? this.summaryErrorState,
        externalItemsPricingCompleted:
            externalItemsPricingCompleted ?? this.externalItemsPricingCompleted,
        errorMsg: errorMsg ?? this.errorMsg,
      );

  @override
  List<Object?> get props => [
        pageLoading,
        acceptanceStatus,
        returnToGroup,
        salesReturn,
        customerNotified,
        selectedUser,
        feed,
        maintenanceSummary,
        submittingReport,
        submittingExternalItems,
        reportSubmitted,
        loadingsummary,
        summaryErrorState,
        externalItemsPricingCompleted,
        errorMsg,
      ];
}

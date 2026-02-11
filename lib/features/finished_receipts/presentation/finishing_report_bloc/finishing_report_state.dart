part of 'finishing_report_bloc.dart';

class FinishingReportState extends Equatable {
  final int containerId;
  final FinishingReport? finishingReport;
  final CheckoutFormData? checkoutFormData;
  final bool isLoading;
  final bool checkoutLoading;
  final bool finished;

  const FinishingReportState({
    this.containerId = 0,
    this.finishingReport,
    this.isLoading = false,
    this.checkoutLoading = false,
    this.finished = false,
    this.checkoutFormData = null,
  });

  const FinishingReportState.initial()
      : this(
            containerId: 0,
            isLoading: true,
            checkoutLoading: false,
            finished: false);

  FinishingReportState copyWith({
    int? containerId,
    FinishingReport? finishingReport,
    CheckoutFormData? checkoutFormData,
    bool? isLoading,
    bool? checkoutLoading,
    bool? finished,
  }) {
    return FinishingReportState(
      containerId: containerId ?? this.containerId,
      isLoading: isLoading ?? this.isLoading,
      finishingReport: finishingReport ?? this.finishingReport,
      checkoutFormData: checkoutFormData ?? this.checkoutFormData,
      checkoutLoading: checkoutLoading ?? this.checkoutLoading,
      finished: finished ?? this.finished,
    );
  }

  @override
  List<Object?> get props => [
        containerId,
        isLoading,
        finishingReport,
        checkoutFormData,
        checkoutLoading,
        finished,
      ];
}

class FinishingReportErrorState extends FinishingReportState {
  final TranslatableValue errorMessage;

  FinishingReportErrorState({required this.errorMessage});
}

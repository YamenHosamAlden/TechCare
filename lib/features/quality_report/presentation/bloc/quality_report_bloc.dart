import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/external_item.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/group_user.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/maintenance_summary.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report_feed.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/get_maintenance_summary_usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/load_quality_report_feed_usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/submit_priced_items%20_usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/submit_q_report_usecase.dart';
part 'quality_report_event.dart';
part 'quality_report_state.dart';

class QualityReportBloc extends Bloc<QualityReportEvent, QualityReportState> {
  final LoadQualityReportFeedUsecase loadQualityReportFeedUsecase;
  final SubmitQReportUsecase submitQReportUsecase;
  final SubmitPricedItemsUsecase submitPricedItemsUsecase;
  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;
  final GetMaintenanceSummaryUsecase getMaintenanceSummaryUsecase;

  QualityReportBloc({
    required this.viewSnackBarMsgUsecase,
    required this.loadQualityReportFeedUsecase,
    required this.submitQReportUsecase,
    required this.submitPricedItemsUsecase,
    required this.getMaintenanceSummaryUsecase,
  }) : super(QualityReportState.initial()) {
    on<LoadQualityReportFeed>(_onLoadQualityReportFeed);
    on<ChangeAcceptanceStatus>(_onChangeAcceptanceStatus);
    on<SalesReturnStatusChanged>(_onSalesReturnStatusChanged);
    on<SelectUser>(_onSelectUser);
    on<ReturnToGroup>(_onReturnToGroup);
    on<CustomerNotified>(_onCustomerNotified);
    on<SubmitQualityReport>(_onSubmitQualityReport);
    on<SubmitExternalItems>(_onSubmitExternalItems);
    on<LoadMaintenanceSummary>(_LoadMaintenanceSummary);
  }

  FutureOr<void> _onLoadQualityReportFeed(
      LoadQualityReportFeed event, Emitter<QualityReportState> emit) async {
    emit(state.copyWith(pageLoading: true));
    await loadQualityReportFeedUsecase(event.deviceId)
        .then((value) => value.fold((failure) {
              emit(state.copyWith(
                pageLoading: false,
                errorMsg: mapFailureToMsg(failure),
              ));
            }, (feed) {
              emit(state.copyWith(
                pageLoading: false,
                feed: feed,
                externalItemsPricingCompleted: feed.externalItems.isEmpty,
              ));
              if (feed.externalItems.isEmpty) {
                this.add(LoadMaintenanceSummary(deviceId: event.deviceId));
              }
            }));
  }

  FutureOr<void> _onChangeAcceptanceStatus(
      ChangeAcceptanceStatus event, Emitter<QualityReportState> emit) {
    if (event.acceptanceStatus) {
      emit(state.copyWith(
          acceptanceStatus: event.acceptanceStatus,
          returnToGroup: false,
          removeSelectedUser: true));
    } else {
      emit(state.copyWith(
        acceptanceStatus: event.acceptanceStatus,
        salesReturn: false,
        customerNotified: false,
      ));
    }
  }

  FutureOr<void> _onReturnToGroup(
      ReturnToGroup event, Emitter<QualityReportState> emit) {
    emit(state.copyWith(
        returnToGroup: event.isReturnToGroup, removeSelectedUser: true));
  }

  FutureOr<void> _onSalesReturnStatusChanged(
      SalesReturnStatusChanged event, Emitter<QualityReportState> emit) {
    emit(state.copyWith(salesReturn: event.isSalesReturn));
  }

  FutureOr<void> _onCustomerNotified(
      CustomerNotified event, Emitter<QualityReportState> emit) {
    emit(state.copyWith(customerNotified: event.isNotified));
  }

  FutureOr<void> _onSelectUser(
      SelectUser event, Emitter<QualityReportState> emit) {
    emit(state.copyWith(selectedUser: event.user));
  }

  FutureOr<void> _onSubmitQualityReport(
      SubmitQualityReport event, Emitter<QualityReportState> emit) async {
    emit(state.copyWith(submittingReport: true));
    await submitQReportUsecase(ReportParams(
        deviceId: event.deviceId,
        qualityReport: QualityReport(
          isAccepted: state.acceptanceStatus,
          testDuration: event.testDuration,
          fixedCost: event.fixedCost,
          isSalesReturn: state.salesReturn,
          isNotified: state.customerNotified,
          isReturnToGroup: state.returnToGroup,
          user: state.selectedUser,
          report: event.report,
        ))).then((value) => value.fold(
          (failure) {
            viewSnackBarMsgUsecase(
                SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
            emit(state.copyWith(submittingReport: false));
          },
          (r) {
            viewSnackBarMsgUsecase(SnackBarMessageConfig(
                color: AppColors.eucalyptusColor,
                msg: TranslatableValue.fromTranslations(
                    translations: Translation(
                        en: "Report created", ar: "تم إنشاء التقرير"))));
            emit(state.copyWith(reportSubmitted: true));
          },
        ));
  }

  FutureOr<void> _onSubmitExternalItems(
      SubmitExternalItems event, Emitter<QualityReportState> emit) async {
    print(event.deviceId);
    print(event.pricedExternalItems);

    emit(state.copyWith(submittingExternalItems: true));
    await submitPricedItemsUsecase(SubmitPricedItemsParams(
            deviceId: event.deviceId, pricedItems: event.pricedExternalItems))
        .then((value) => value.fold(
              (failure) {
                viewSnackBarMsgUsecase(
                    SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
                emit(state.copyWith(submittingExternalItems: false));
              },
              (r) {
                emit(state.copyWith(externalItemsPricingCompleted: true));
                this.add(LoadMaintenanceSummary(deviceId: event.deviceId));
              },
            ));
  }

  FutureOr<void> _LoadMaintenanceSummary(
      LoadMaintenanceSummary event, Emitter<QualityReportState> emit) async {
    emit(state.copyWith(loadingsummary: true));
    await getMaintenanceSummaryUsecase(event.deviceId)
        .then((value) => value.fold((failure) {
              viewSnackBarMsgUsecase(
                SnackBarMessageConfig(msg: mapFailureToMsg(failure)),
              );
              emit(state.copyWith(
                loadingsummary: false,
                summaryErrorState: true,
              ));
            }, (summary) {
              emit(state.copyWith(
                maintenanceSummary: summary,
                loadingsummary: false,
                summaryErrorState: false,
              ));
            }));
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/core/util/helpers/round_num.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/checkout_form_data.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/finishing_report.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/checkout_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/get_finishing_report.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';

part 'finishing_report_event.dart';
part 'finishing_report_state.dart';

class FinishingReportBloc
    extends Bloc<FinishingReportEvent, FinishingReportState> {
  final GetFinishingReportUsecase getFinishingReportUsecase;
  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;

  final CheckoutUsecase checkoutUsecase;
  FinishingReportBloc({
    required this.viewSnackBarMsgUsecase,
    required this.getFinishingReportUsecase,
    required this.checkoutUsecase,
  }) : super(FinishingReportState.initial()) {
    on<GetFinishingReport>(_onGetFinishingReport);
    on<UpdateDeviceAmountReceived>(_onUpdateDeviceAmountReceived);
    on<Checkout>(_onCheckout);
  }

  FutureOr<void> _onGetFinishingReport(
      GetFinishingReport event, Emitter<FinishingReportState> emit) async {
    emit(state.copyWith(isLoading: true, containerId: event.containerId));
    await getFinishingReportUsecase(event.containerId).then(
      (value) => value.fold((failure) {
        emit(FinishingReportErrorState(errorMessage: mapFailureToMsg(failure)));
      }, (finishingReport) {
        num totalAmount;
        try {
          totalAmount =
              num.parse(finishingReport.totalFixedCost.replaceAll(',', ''))
                  .toDouble();
        } catch (e) {
          totalAmount = 0.0;
        }
        emit(state.copyWith(
            isLoading: false,
            finishingReport: finishingReport,
            checkoutFormData: CheckoutFormData(
                amounts: finishingReport.devices.map((device) {
                  num amount;
                  try {
                    amount = num.parse(device.fixedCost.replaceAll(',', ''));
                  } catch (e) {
                    amount = 0.0;
                  }

                  return DeviceAmountReceived(
                    deviceId: device.id,
                    deviceCode: device.deviceCode,
                    amount: amount,
                  );
                }).toList(),
                totalAmount: totalAmount,
                note: '')));
      }),
    );
  }

  FutureOr<void> _onCheckout(
      Checkout event, Emitter<FinishingReportState> emit) async {
    emit(state.copyWith(checkoutLoading: true));
    final tempCheckoutForm = state.checkoutFormData!.copyWith(note: event.note);
    await checkoutUsecase(CheckoutParams(
      containerId: state.containerId,
      checkoutFormData: tempCheckoutForm,
    )).then((value) => value.fold((failure) {
          viewSnackBarMsgUsecase(
              SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
          emit(state.copyWith(checkoutLoading: false));
        }, (r) => emit(state.copyWith(finished: true))));
  }

  FutureOr<void> _onUpdateDeviceAmountReceived(
      UpdateDeviceAmountReceived event, Emitter<FinishingReportState> emit) {
    final newAmounts = state.checkoutFormData!.amounts.map((amount) {
      if (amount.deviceId == event.deviceId) {
        return amount.copyWith(amount: event.amount);
      }
      return amount;
    }).toList();

    num newTotalAmount = 0.0;

    newAmounts.forEach((amount) {
      newTotalAmount += amount.amount;
    });
    newTotalAmount = roundNum(newTotalAmount, 2);
    emit(state.copyWith(
      checkoutFormData: state.checkoutFormData!.copyWith(
        amounts: newAmounts,
        totalAmount: newTotalAmount,
      ),
    ));
    // print(state.checkoutFormData!.amounts);
  }
}

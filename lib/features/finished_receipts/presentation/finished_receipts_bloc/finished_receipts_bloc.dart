import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/load_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/load_more_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/reload_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/reset_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';

part 'finished_receipts_event.dart';
part 'finished_receipts_state.dart';

class FinishedReceiptsBloc
    extends Bloc<FinishedReceiptsEvent, FinishedReceiptsState> {
  final LoadFinishedReceiptsUsecase loadFinishedReceiptsUsecase;
  final ReloadFinishedReceiptsUsecase reloadFinishedReceiptsUsecase;
  final LoadMoreFinishedReceiptsUsecase loadMoreFinishedReceiptsUsecase;
  final ResetFinishedReceiptsUsecase resetFinishedReceiptsUsecase;
  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;

  FinishedReceiptsBloc(
      {required this.viewSnackBarMsgUsecase,
      required this.loadFinishedReceiptsUsecase,
      required this.reloadFinishedReceiptsUsecase,
      required this.resetFinishedReceiptsUsecase,
      required this.loadMoreFinishedReceiptsUsecase})
      : super(FinishedReceiptsState.initial()) {
    on<LoadFinishedReceiptsList>(_onLoadFinishedReceiptsList);
    on<ReloadFinishedReceipts>(_onReloadFinishedReceipts);
    on<LoadMoreFinishedReceipts>(_onLoadMoreFinishedReceipts);
  }

  FutureOr<void> _onLoadFinishedReceiptsList(LoadFinishedReceiptsList event,
      Emitter<FinishedReceiptsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await loadFinishedReceiptsUsecase(Void).then((value) => value.fold(
            (failure) {
          viewSnackBarMsgUsecase(
              SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
          emit(FinishedReceiptsErrorState(
              errorMessage: mapFailureToMsg(failure)));
        },
            (finishedReceiptsList) => emit(
                state.copyWith(isLoading: false, finishedReceiptsList: finishedReceiptsList))));
  }

  FutureOr<void> _onReloadFinishedReceipts(
      ReloadFinishedReceipts event, Emitter<FinishedReceiptsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await reloadFinishedReceiptsUsecase(Void).then((value) => value.fold(
            (failure) {
          viewSnackBarMsgUsecase(
              SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
          emit(FinishedReceiptsErrorState(
              errorMessage: mapFailureToMsg(failure)));
        },
            (finishedReceiptsList) => emit(
                state.copyWith(isLoading: false, finishedReceiptsList: finishedReceiptsList))));
  }

  FutureOr<void> _onLoadMoreFinishedReceipts(LoadMoreFinishedReceipts event,
      Emitter<FinishedReceiptsState> emit) async {
    emit(state.copyWith(loadMore: true));
    await loadMoreFinishedReceiptsUsecase(Void).then((value) => value.fold(
            (failure) {
          viewSnackBarMsgUsecase(
              SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
          emit(FinishedReceiptsErrorState(
              errorMessage: mapFailureToMsg(failure)));
        },
            (finishedReceiptsList) =>
                emit(state.copyWith(loadMore: false, finishedReceiptsList: finishedReceiptsList))));
  }

  @override
  Future<void> close() {
    this.resetFinishedReceiptsUsecase(Void);
    return super.close();
  }
}

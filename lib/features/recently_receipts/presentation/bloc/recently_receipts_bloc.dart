import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/load_more_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/get_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/reload_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/reset_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

part 'recently_receipts_event.dart';
part 'recently_receipts_state.dart';

class RecentlyReceiptsBloc
    extends Bloc<RecentlyReceiptsEvent, RecentlyReceiptsState> {
  ResetRecentlyReceiptsUsecase resetRecentlyReceiptsUsecase;
  GetRecentlyReceiptsUsecase getRecentlyReceiptsUsecase;
  LoadMoreRecentlyReceiptsUsecase loadMoreRecentlyReceiptsUsecase;
  ReloadRecentlyReceiptsUsecase reloadRecentlyReceiptsUsecase;
  ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;
  RecentlyReceiptsBloc(
      {required this.resetRecentlyReceiptsUsecase,
      required this.getRecentlyReceiptsUsecase,
      required this.viewSnackBarMsgUsecase,
      required this.loadMoreRecentlyReceiptsUsecase,
      required this.reloadRecentlyReceiptsUsecase})
      : super(RecentlyReceiptsState.init()) {
    on<GetRecentlyReceipts>(_onGetRecentlyReceiptsEvent);
    on<ReloadRecentlyReceipts>(_onReloadRecentlyReceipts);
    on<LoadMoreRecentlyReceipts>(_onLoadMoreRecentlyReceipts);
  }

  FutureOr<void> _onGetRecentlyReceiptsEvent(GetRecentlyReceipts event,
      Emitter<RecentlyReceiptsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await getRecentlyReceiptsUsecase(Void).then((value) {
      value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(RecentlyReceiptsErrorState(
            errorMessage: mapFailureToMsg(failure)));
      }, (recentlyReceiptsList) {
        emit(state.copyWith(
            isLoading: false, recentlyReceiptsList: recentlyReceiptsList));
      });
    });
  }

  FutureOr<void> _onReloadRecentlyReceipts(
      ReloadRecentlyReceipts event,
      Emitter<RecentlyReceiptsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await reloadRecentlyReceiptsUsecase(Void).then((value) {
      value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(RecentlyReceiptsErrorState(
            errorMessage: mapFailureToMsg(failure)));
      }, (recentlyReceiptsList) {
        emit(state.copyWith(
            isLoading: false, recentlyReceiptsList: recentlyReceiptsList));
      });
    });
  }

  FutureOr<void> _onLoadMoreRecentlyReceipts(
      LoadMoreRecentlyReceipts event,
      Emitter<RecentlyReceiptsState> emit) async {
    emit(state.copyWith(loadMore: true));
    await loadMoreRecentlyReceiptsUsecase(Void).then((value) {
      value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(RecentlyReceiptsErrorState(
            errorMessage: mapFailureToMsg(failure)));
      }, (recentlyReceiptsList) {
        emit(state.copyWith(
            loadMore: false, recentlyReceiptsList: recentlyReceiptsList));
      });
    });
  }

  @override
  Future<void> close() {
    this.resetRecentlyReceiptsUsecase(Void);
    return super.close();
  }
}

import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_create_receipt_res_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_device_res_usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/get_maintenance_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/get_quality_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/get_received_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/load_more_maintenance_receipts_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/load_more_quality_receipts_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/load_more_received_receipts_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/receipts_event_stream_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/reload_maintenance_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/reload_quality_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/reload_received_list_usecase.dart';

part 'receipts_event.dart';
part 'receipts_state.dart';

class ReceiptsBloc extends Bloc<ReceiptsEvent, ReceiptsState> {
  final GetReceivedListUsecase getReceivedListUsecase;
  final GetMaintenanceListUsecase getMaintenanceListUsecase;
  final GetQualityListUsecase getQualityListUsecase;

  final ReloadReceivedListUsecase reloadReceivedListUsecase;
  final ReloadMaintenanceListUsecase reloadMaintenanceListUsecase;
  final ReloadQualityListUsecase reloadQualityListUsecase;

  final LoadMoreReceivedReceiptsUsecase loadMoreReceivedReceiptsUsecase;
  final LoadMoreMaintenanceReceiptsUsecase loadMoreMaintenanceReceiptsUsecase;
  final LoadMoreQualityReceiptsUsecase loadMoreQualityReceiptsUsecase;
  final LoadCreateReceiptResUsecase loadCreateReceiptResUsecase;
  final LoadDeviceResUsecase loadDeviceResUsecase;

  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;
  final ReceiptsEventStreamUsecase receiptsEventStreamUsecase;

  late StreamSubscription<ReceiptsEvent> _receiptsEventStreamSubscription;

  ReceiptsBloc({
    required this.getReceivedListUsecase,
    required this.getMaintenanceListUsecase,
    required this.getQualityListUsecase,
    required this.reloadReceivedListUsecase,
    required this.reloadMaintenanceListUsecase,
    required this.reloadQualityListUsecase,
    required this.loadMoreReceivedReceiptsUsecase,
    required this.loadMoreMaintenanceReceiptsUsecase,
    required this.loadMoreQualityReceiptsUsecase,
    required this.viewSnackBarMsgUsecase,
    required this.receiptsEventStreamUsecase,
    required this.loadCreateReceiptResUsecase,
    required this.loadDeviceResUsecase,
  }) : super(ReceiptsState.initial()) {
    on<LoadReceivedList>(_onLoadReceivedList);
    on<LoadMaintenanceList>(_onLoadMaintenanceList);
    on<LoadQualityList>(_onLoadQualityList);

    on<ReloadReceivedList>(_onReloadReceivedList);
    on<ReloadMaintenanceList>(_onReloadMaintnanceList);
    on<ReloadQualityList>(_onReloadQualityList);

    on<LoadMoreReceivedReceipts>(_onLoadMoreReceivedReciepts);
    on<LoadMoreMaintenanceReceipts>(_onLoadMoreMaintenanceReciepts);
    on<LoadMoreQualityReceipts>(_onLoadMoreQualityReciepts);
    on<LoadAllReceipts>(_onLoadAllReceipts);
    on<AddToReceivedList>(_onAddToReceivedList);

    receiptsEventStreamUsecase(Void).then((value) {
      value.fold((failure) => null, (receiptsEventStream) {
        _receiptsEventStreamSubscription =
            receiptsEventStream.listen((receiptsEvent) => add(receiptsEvent));
      });
    });
  }

  FutureOr<void> _onAddToReceivedList(
      AddToReceivedList event, Emitter<ReceiptsState> emit) async {
    emit(state.copyWith(loadingMaintenance: true));
    emit(state.copyWith(loadingMaintenance: false, setPageIndex: 0));
  }

  _onLoadAllReceipts(LoadAllReceipts event, Emitter<ReceiptsState> emit) {
    loadDeviceResUsecase(NoParams());
    loadCreateReceiptResUsecase(NoParams());
    add(LoadReceivedList());
    add(LoadMaintenanceList());
    add(LoadQualityList());
  }

  FutureOr<void> _onLoadReceivedList(
      ReceiptsEvent event, Emitter<ReceiptsState> emit) async {
    if (state.loadingReceived) {
      return;
    }
    emit(state.copyWith(loadingReceived: true));

    await getReceivedListUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingReceived: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(loadingReceived: false, receivedList: receiptList));
      }),
    );
  }

  FutureOr<void> _onLoadMaintenanceList(
      LoadMaintenanceList event, Emitter<ReceiptsState> emit) async {
    if (state.loadingMaintenance) {
      return;
    }
    emit(state.copyWith(loadingMaintenance: true));
    await getMaintenanceListUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingMaintenance: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(
            loadingMaintenance: false, maintenanceList: receiptList));
      }),
    );
  }

  FutureOr<void> _onLoadQualityList(
      LoadQualityList event, Emitter<ReceiptsState> emit) async {
    if (state.loadingQuality) {
      return;
    }
    emit(state.copyWith(loadingQuality: true));
    await getQualityListUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingQuality: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(loadingQuality: false, qualityList: receiptList));
      }),
    );
  }

  FutureOr<void> _onReloadReceivedList(
      ReloadReceivedList event, Emitter<ReceiptsState> emit) async {
    if (state.loadingReceived) {
      return;
    }
    emit(state.copyWith(loadingReceived: true));
    await reloadReceivedListUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingReceived: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(loadingReceived: false, receivedList: receiptList));
      }),
    );
  }

  FutureOr<void> _onReloadMaintnanceList(
      ReloadMaintenanceList event, Emitter<ReceiptsState> emit) async {
    if (state.loadingMaintenance) {
      return;
    }
    emit(state.copyWith(loadingMaintenance: true));
    await reloadMaintenanceListUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingMaintenance: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(
            loadingMaintenance: false, maintenanceList: receiptList));
      }),
    );
  }

  FutureOr<void> _onReloadQualityList(
      ReloadQualityList event, Emitter<ReceiptsState> emit) async {
    if (state.loadingQuality) {
      return;
    }
    emit(state.copyWith(loadingQuality: true));
    await reloadQualityListUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingQuality: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(loadingQuality: false, qualityList: receiptList));
      }),
    );
  }

  FutureOr<void> _onLoadMoreReceivedReciepts(
      LoadMoreReceivedReceipts event, Emitter<ReceiptsState> emit) async {
    if (state.loadingMoreReceived) {
      return;
    }
    emit(state.copyWith(loadingMoreReceived: true));
    await loadMoreReceivedReceiptsUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingMoreReceived: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(
            loadingMoreReceived: false, receivedList: receiptList));
      }),
    );
  }

  FutureOr<void> _onLoadMoreMaintenanceReciepts(
      LoadMoreMaintenanceReceipts event, Emitter<ReceiptsState> emit) async {
    if (state.loadingMoreMaintenance) {
      return;
    }
    emit(state.copyWith(loadingMoreMaintenance: true));
    await loadMoreMaintenanceReceiptsUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingMoreMaintenance: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(
            loadingMoreMaintenance: false, maintenanceList: receiptList));
      }),
    );
  }

  FutureOr<void> _onLoadMoreQualityReciepts(
      LoadMoreQualityReceipts event, Emitter<ReceiptsState> emit) async {
    if (state.loadingMoreQuality) {
      return;
    }
    emit(state.copyWith(loadingMoreQuality: true));
    await loadMoreQualityReceiptsUsecase(Void).then(
      (value) => value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(
          loadingMoreQuality: false,
        ));
      }, (receiptList) {
        emit(state.copyWith(
            loadingMoreQuality: false, qualityList: receiptList));
      }),
    );
  }

  @override
  Future<void> close() {
    _receiptsEventStreamSubscription.cancel();

    return super.close();
  }
}

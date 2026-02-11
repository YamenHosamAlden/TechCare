import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/entity/device_info.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/load_more_search_by_device_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/load_more_search_by_receipt_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/search_by_device_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/search_by_receipt_usecase.dart';
import 'package:tech_care_app/features/saerch/presentation/pages/search_page.dart';

part 'saerch_event.dart';
part 'saerch_state.dart';

class SaerchBloc extends Bloc<SaerchEvent, SaerchState> {
  final LoadMoreSearchByReceiptUsecase loadMoreSearchByReceiptUsecase;
  final LoadMoreSearchByDeviceUsecase loadMoreSearchByDeviceUsecase;
  final SearchByReceiptUsecase searchByReceiptUsecase;
  final SearchByDeviceUsecase searchByDeviceUsecase;
  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;

  SaerchBloc(
      {required this.searchByReceiptUsecase,
      required this.searchByDeviceUsecase,
      required this.viewSnackBarMsgUsecase,
      required this.loadMoreSearchByDeviceUsecase,
      required this.loadMoreSearchByReceiptUsecase})
      : super(SaerchState.initial()) {
    on<ChangeSearchType>(_onChangeSearchType);
    // on<LoadMoreResults>(_onLoadMoreResults);
    on<Search>(_onSearch);
    on<LoadMoreSearchByDevice>(_onLoadMoreSearchByDevice);
    on<LoadMoreSearchByReceipt>(_onLoadMoreSearchByReceipt);
  }

  FutureOr<void> _onChangeSearchType(
      ChangeSearchType event, Emitter<SaerchState> emit) {
    print(event.searchType);
    emit(state.copyWith(searchType: event.searchType));
  }

  FutureOr<void> _onSearch(Search event, Emitter<SaerchState> emit) async {
    if (event.term.trim().isEmpty) {
      return;
    }

    emit(state.copyWith(loadingResults: true, searchTerm: event.term, page: 1));

    if (state.searchType == SearchType.device) {
      print('search by device');
      await searchByDeviceUsecase(event.term).then((value) => value.fold(
            (failure) {
              viewSnackBarMsgUsecase(
                  SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
              emit(state.copyWith(loadingResults: false));
            },
            (devices) => emit(state.copyWith(
                devices: devices, receipts: [], loadingResults: false)),
          ));
    } else {
      print('search by receipt');

      await searchByReceiptUsecase(event.term).then((value) => value.fold(
            (failure) {
              viewSnackBarMsgUsecase(
                  SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
              emit(state.copyWith(loadingResults: false));
            },
            (receipts) => emit(state.copyWith(
                receipts: receipts, devices: [], loadingResults: false)),
          ));
    }
  }

  FutureOr<void> _onLoadMoreSearchByDevice(
      LoadMoreSearchByDevice event, Emitter<SaerchState> emit) async {
    int page = state.page;
    page++;

    if (event.term.trim().isEmpty) {
      return;
    }

    emit(state.copyWith(
        loadMoreDevice: true, searchTerm: event.term, page: page));

    if (state.searchType == SearchType.device) {
      await loadMoreSearchByDeviceUsecase(
              SearchByDeviceParams(trem: event.term, page: state.page))
          .then((value) => value.fold((failure) {
                viewSnackBarMsgUsecase(
                    SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
                emit(state.copyWith(loadMoreDevice: false));
              }, (devicesList) {
                List<DeviceInfo> devices = state.devices;
                _checkDevicesDuplication(
                    baseList: devices, newDevices: devicesList);
                emit(state.copyWith(
                    devices: devices, receipts: [], loadMoreDevice: false));
              }));
    }
  }

  FutureOr<void> _onLoadMoreSearchByReceipt(
      LoadMoreSearchByReceipt event, Emitter<SaerchState> emit) async {
    int page = state.page;
    page++;

    if (event.term.trim().isEmpty) {
      return;
    }

    emit(state.copyWith(
        loadMoreReceipts: true, searchTerm: event.term, page: page));

    if (state.searchType == SearchType.receipt) {
      await loadMoreSearchByReceiptUsecase(
              SearchByReceiptParams(trem: event.term, page: state.page))
          .then((value) => value.fold((failure) {
                viewSnackBarMsgUsecase(
                    SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
                emit(state.copyWith(loadMoreDevice: false));
              }, (receiptList) {
                List<ReceiptContainer> receipts = state.receipts;
                _checkReceiptsDuplication(
                    baseList: state.receipts, newReceipts: receiptList);

                emit(state.copyWith(
                    devices: [], receipts: receipts, loadMoreReceipts: false));
              }));
    }
  }

  void _checkReceiptsDuplication(
      {required List<ReceiptContainer> baseList,
      required List<ReceiptContainer> newReceipts}) {
    newReceipts.forEach((newReceipt) {
      if (baseList.contains(newReceipt)) {
        return;
      }
      baseList.add(newReceipt);
    });
  }

  void _checkDevicesDuplication(
      {required List<DeviceInfo> baseList,
      required List<DeviceInfo> newDevices}) {
    newDevices.forEach((newDevices) {
      if (baseList.contains(newDevices)) {
        return;
      }
      baseList.add(newDevices);
    });
  }
}

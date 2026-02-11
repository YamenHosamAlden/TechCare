// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';

import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/delete_receipt_usecase.dart';

part 'delete_receipt_event.dart';
part 'delete_receipt_state.dart';

class DeleteReceiptBloc extends Bloc<DeleteReceiptEvent, DeleteReceiptState> {
  DeleteReceiptUsecase deleteReceiptUsecase;
  ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;
  DeleteReceiptBloc({
    required this.deleteReceiptUsecase,
    required this.viewSnackBarMsgUsecase,
  }) : super(DeleteReceiptState.init()) {
    on<DeleteReceiptEvent>(_onDeleteReceiptEvent);
  }
  FutureOr<void> _onDeleteReceiptEvent(
      DeleteReceiptEvent event, Emitter<DeleteReceiptState> emit) async {
    emit(state.copyWith(isLoading: true));
    await deleteReceiptUsecase(event.containerId).then((value) {
      value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(isLoading: false));
      }, (v) {
        emit(state.copyWith(
          isLoading: false,
        
        ));
      });
    });
  }
}

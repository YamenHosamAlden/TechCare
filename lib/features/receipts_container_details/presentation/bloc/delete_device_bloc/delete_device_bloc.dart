import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/delete_device_usecase.dart';

part 'delete_device_event.dart';
part 'delete_device_state.dart';

class DeleteDeviceBloc extends Bloc<DeleteDeviceEvent, DeleteDeviceState> {
  ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;
  DeleteDeviceUsecase deleteDeviceUsecase;
  DeleteDeviceBloc(
      {required this.viewSnackBarMsgUsecase, required this.deleteDeviceUsecase})
      : super(DeleteDeviceState.init()) {
    on<DeleteDeviceEvent>(_onDeleteDeviceEvent);
  }

  FutureOr _onDeleteDeviceEvent(
      DeleteDeviceEvent event, Emitter<DeleteDeviceState> emit) async {
    emit(state.copyWith(isLoading: true));
    await deleteDeviceUsecase(event.deviceId).then((value) {
      value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(isLoading: false));
      }, (v) {
        viewSnackBarMsgUsecase(SnackBarMessageConfig(
            color: AppColors.eucalyptusColor,
            msg: TranslatableValue.fromTranslations(
                translations: Translation(
                    en: "The device has been deleted", ar: "تم حذف الجهاز"))));

        emit(state.copyWith(isLoading: false, isComplete: true));
      });
    });
  }
}

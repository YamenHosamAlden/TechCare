import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutUsecase logoutUsecase;
  ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;
  LogoutBloc(
      {required this.logoutUsecase, required this.viewSnackBarMsgUsecase})
      : super(LogoutState.init()) {
    on<LogoutEvent>(_logOut);
  }

  FutureOr _logOut(LogoutEvent event, Emitter<LogoutState> emit) async {
    emit(state.copyWith(isLoading: true));

    await logoutUsecase(NoParams()).then((value) {
      value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(isLoading: false));
      }, (done) {
        emit(state.copyWith(isLoading: false));
      });
    });
  }
}

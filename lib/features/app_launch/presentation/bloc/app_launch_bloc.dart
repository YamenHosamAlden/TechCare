import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/app_launch/domain/entity/version_status.dart';
import 'package:tech_care_app/features/app_launch/domain/usecase/check_app_status_usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/dialog_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_dialog_msg_usecase.dart';

part 'app_launch_event.dart';
part 'app_launch_state.dart';

class AppLaunchBloc extends Bloc<AppLaunchEvent, AppLaunchState> {
  final CheckAppStatusUsecase checkAppStatusUsecase;
  final ViewDialogMsgUsecase viewDialogMsgUsecase;
 

  AppLaunchBloc(
      {required this.checkAppStatusUsecase,
      required this.viewDialogMsgUsecase,
    })
      : super(AppLaunchInitialState()) {
    on<AppLaunchInitialEvent>(_onAppLaunchInitialEvent);
    on<SkipUpdateEvent>(_onSkipUpdateEvent);
  }

 

  Future<void> _onAppLaunchInitialEvent(
    AppLaunchInitialEvent event,
    Emitter<AppLaunchState> emit,
  ) async {

    print("event: " + AppLaunchInitialEvent().toString());
    emit(AppLaunchInitialState());
    await checkAppStatusUsecase(NoParams())
        .then((value) => value.fold((failure) {
              viewDialogMsgUsecase(DialogMessageConfig(
                dismissible: false,
                dialogType: DialogType.error,
                msg: mapFailureToMsg(failure),
                onRetry: () => add(AppLaunchInitialEvent()),
              ));
              // emit(AppLaunchingErorr(errorMsg: mapFailureToMsg(failure)));
            }, (versionStatus) {
              if (versionStatus.apiStatus == ApiStatus.DOWN) {
                emit(UpdatingService());
              } else if (versionStatus.appStatus != AppStatus.NONE) {
                emit(NewUpdate(versionStatus: versionStatus));
              } else {
                emit(AppLaunchingComplete());
              }
            }));
  }

  Future<void> _onSkipUpdateEvent(
    SkipUpdateEvent event,
    Emitter<AppLaunchState> emit,
  ) async {
    emit(AppLaunchingComplete());
  }
}

import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/auth/domain/usecases/get_user_usercase.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/add_note_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/device_details_event_stream_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/get_device_details_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/pause_timer_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/start_timer_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/unreceive_device_usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
part 'device_details_event.dart';
part 'device_details_state.dart';

class DeviceDetailsBloc extends Bloc<DeviceDetailsEvent, DeviceDetailsState> {
  Timer? timer;
  final DeviceDetailsEventStreamUsecase deviceDetailsEventStreamUsecase;
  final GetDeviceDetailsUsecase getDeviceDetailsUsecase;
  final StartTimerUsecase startTimerUsecase;
  final PauseTimerUsecase pauseTimerUsecase;
  final AddNoteUsecase addNoteUsecase;
  final UnreceiveDeviceUsecase unreceiveDeviceUsecase;
  final GetUserUsecase getUserUsecase;
  final ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;

  late final StreamSubscription<DeviceDetailsEvent> eventStreamSubscription;

  DeviceDetailsBloc(
      {required this.deviceDetailsEventStreamUsecase,
      required this.getDeviceDetailsUsecase,
      required this.startTimerUsecase,
      required this.pauseTimerUsecase,
      required this.addNoteUsecase,
      required this.unreceiveDeviceUsecase,
      required this.getUserUsecase,
      required this.viewSnackBarMsgUsecase})
      : super(DeviceDetailsState.initial()) {
    on<GetDeviceInfo>(_onGetDeviceInfo);
    on<_TickEvent>(_onTickEvent);
    on<StartTimer>(_onStartTimerEvent);
    on<PauseTimer>(_onPauseTimerEvent);
    on<UnreceiveDevice>(_onUnreceiveDevice);
    on<AddNote>(_onAddNote);
    on<AddReport>(_onAddReport);
    on<_RemoveRecentlyAddedReportState>(_onRemoveRecentlyAddedReportState);

    deviceDetailsEventStreamUsecase(Void).then(
      (value) => value.fold(
        (l) => null,
        (eventsStream) {
          eventStreamSubscription = eventsStream.listen((event) {
            this.add(event);
          });
        },
      ),
    );
  }

  @override
  Future<void> close() {
    timer?.cancel();
    eventStreamSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onGetDeviceInfo(
      GetDeviceInfo event, Emitter<DeviceDetailsState> emit) async {
    emit(state.copyWith(isLoading: true));
    int? currentUserId;
    await getUserUsecase(Void).then((value) => value.fold(
        (l) => currentUserId = -1, (user) => currentUserId = user.id));

    await getDeviceDetailsUsecase(
            Params(deviceID: event.deviceID, deviceCode: event.deviceCode))
        .then((value) => value.fold((failure) {
              emit(DeviceDetailsErrorState(
                  errorMessage: mapFailureToMsg(failure)));
            }, (deviceDetails) {
              emit(state.copyWith(
                  isLoading: false,
                  duration: deviceDetails.process.time,
                  deviceDetails: deviceDetails,
                  timerStatus: deviceDetails.process.timerStatus,
                  hideDeviceActoiinsButtons:
                      currentUserId != deviceDetails.deviceInfo.assignId));

              emit(state.copyWith(stateType: DeviceDetailsStateType.TICKER));
              timer?.cancel();
              if (deviceDetails.process.timerStatus == TimerStatus.running) {
                _runTimer();
              }
            }));
  }

  void _runTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      add(_TickEvent());
    });
  }

  FutureOr<void> _onTickEvent(
      _TickEvent event, Emitter<DeviceDetailsState> emit) {
    emit(state.copyWith(
        stateType: DeviceDetailsStateType.TICKER,
        duration: (state.duration ?? 0) + 1));
  }

  FutureOr<void> _onPauseTimerEvent(
      PauseTimer event, Emitter<DeviceDetailsState> emit) async {
    if (state.timerLoading) {
      return;
    }
    emit(state.copyWith(
        stateType: DeviceDetailsStateType.TICKER, timerLoading: true));
    await pauseTimerUsecase(
            PauseTimerParams(deviceID: state.deviceDetails!.deviceInfo.id))
        .then((value) => value.fold((failure) {
              print(failure);
              emit(state.copyWith(
                  stateType: DeviceDetailsStateType.TICKER,
                  timerLoading: false));
            }, (r) {
              timer?.cancel();
              timer = null;
              emit(state.copyWith(
                  timerStatus: TimerStatus.paused,
                  timerLoading: false,
                  stateType: DeviceDetailsStateType.TICKER));
            }));
  }

  FutureOr<void> _onStartTimerEvent(
      StartTimer event, Emitter<DeviceDetailsState> emit) async {
    if (state.timerLoading) {
      return;
    }
    emit(state.copyWith(
        stateType: DeviceDetailsStateType.TICKER, timerLoading: true));

    await startTimerUsecase(
            StartTimerParams(deviceID: state.deviceDetails!.deviceInfo.id))
        .then((value) => value.fold((failure) {
              print(failure);
              emit(state.copyWith(
                  stateType: DeviceDetailsStateType.TICKER,
                  timerLoading: false));
            }, (r) {
              timer?.cancel();
              emit(state.copyWith(
                  timerStatus: TimerStatus.running,
                  timerLoading: false,
                  stateType: DeviceDetailsStateType.TICKER));
              _runTimer();
            }));
  }

  FutureOr<void> _onAddNote(
      AddNote event, Emitter<DeviceDetailsState> emit) async {
    emit(state.copyWith(loadingNote: true));

    await addNoteUsecase(AddNoteParams(
            deviceID: state.deviceDetails!.deviceInfo.id, note: event.note))
        .then((value) => value.fold((failure) {
              viewSnackBarMsgUsecase(
                  SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
              emit(state.copyWith(loadingNote: false));
            }, (report) {
              final List<ProcessReport> reports =
                  List.of(state.deviceDetails!.process.reports!.toList());
              reports.insert(0, report);

              final deviceDetails = DeviceDetails(
                  deviceInfo: state.deviceDetails!.deviceInfo,
                  process: Process(
                      time: state.deviceDetails!.process.time,
                      timerStatus: state.deviceDetails!.process.timerStatus,
                      reports: reports));

              emit(state.copyWith(
                  loadingNote: false,
                  noteAdded: true,
                  deviceDetails: deviceDetails));
              add(_RemoveRecentlyAddedReportState());
            }));
  }

  FutureOr<void> _onAddReport(
      AddReport event, Emitter<DeviceDetailsState> emit) {
    final List<ProcessReport> reports =
        List.of(state.deviceDetails!.process.reports!.toList());
    reports.insert(0, event.report);

    final deviceDetails = DeviceDetails(
        deviceInfo: state.deviceDetails!.deviceInfo.copyWith(
          removeAssignment: true,
        ),
        process: Process(
          time: state.deviceDetails!.process.time,
          timerStatus: state.deviceDetails!.process.timerStatus,
          reports: reports,
        ));

    timer?.cancel();
    emit(state.copyWith(
        duration: 0,
        timerStatus: TimerStatus.paused,
        loadingNote: false,
        noteAdded: true,
        deviceDetails: deviceDetails,
        hideDeviceActoiinsButtons: true));
    add(_RemoveRecentlyAddedReportState());
  }

  FutureOr<void> _onRemoveRecentlyAddedReportState(
      _RemoveRecentlyAddedReportState event,
      Emitter<DeviceDetailsState> emit) async {
        //do not remove this delay
    await Future.delayed(Durations.long2);
    emit(state.copyWith(
        deviceDetails: DeviceDetails(
            deviceInfo: state.deviceDetails!.deviceInfo,
            process: Process(
                time: state.deviceDetails!.process.time,
                timerStatus: state.deviceDetails!.process.timerStatus,
                reports: state.deviceDetails!.process.reports!.map((report) {
                  if (report.isRecentlyAdded) {
                    return report.copyWith(isRecentlyAdded: false);
                  }
                  return report;
                }).toList()))));
  }

  FutureOr<void> _onUnreceiveDevice(
      UnreceiveDevice event, Emitter<DeviceDetailsState> emit) async {
    print('id : ${state.deviceDetails!.deviceInfo.id}');
    emit(state.copyWith(unreceivingDevice: true));
    await unreceiveDeviceUsecase(UnreceiveDeviceParams(
            deviceID: state.deviceDetails!.deviceInfo.id, reason: event.reason))
        .then((value) => value.fold((failure) {
              print(failure);
              emit(state.copyWith(unreceivingDevice: false));
            }, (report) {
              emit(state.copyWith(
                  deviceUnreceived: true, unreceivingDevice: false));
              this.add(AddReport(report: report));
            }));
  }
}

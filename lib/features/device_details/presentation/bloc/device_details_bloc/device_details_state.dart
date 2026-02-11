part of 'device_details_bloc.dart';

enum DeviceDetailsStateType {
  DEFAULT,
  TICKER,
}

class DeviceDetailsState extends Equatable {
  final DeviceDetailsStateType stateType;
  final bool isLoading;
  final bool timerLoading;
  final bool loadingNote;
  final bool noteAdded;
  final bool unreceivingDevice;
  final bool deviceUnreceived;
  final int? duration;
  final TimerStatus? timerStatus;
  final DeviceDetails? deviceDetails;
  final bool hideDeviceActoiinsButtons;

  const DeviceDetailsState({
    this.stateType = DeviceDetailsStateType.DEFAULT,
     this.isLoading=false,
    this.loadingNote = false,
    this.timerLoading = false,
    this.noteAdded = false,
    this.unreceivingDevice = false,
    this.deviceUnreceived = false,
    this.duration,
    this.timerStatus,
    this.deviceDetails,
    this.hideDeviceActoiinsButtons = false,
  });

  const DeviceDetailsState.initial() : this(isLoading: true);

  DeviceDetailsState copyWith({
    DeviceDetailsStateType? stateType = DeviceDetailsStateType.DEFAULT,
    bool? isLoading,
    bool? loadingNote,
    bool? timerLoading,
    bool? noteAdded = false,
    bool? unreceivingDevice,
    bool? deviceUnreceived = false,
    int? duration,
    TimerStatus? timerStatus,
    DeviceDetails? deviceDetails,
    bool? hideDeviceActoiinsButtons,
  }) {
    return DeviceDetailsState(
      stateType: stateType ?? this.stateType,
      isLoading: isLoading ?? this.isLoading,
      loadingNote: loadingNote ?? this.loadingNote,
      duration: duration ?? this.duration,
      timerStatus: timerStatus ?? this.timerStatus,
      deviceDetails: deviceDetails ?? this.deviceDetails,
      noteAdded: noteAdded ?? this.noteAdded,
      unreceivingDevice: unreceivingDevice ?? this.unreceivingDevice,
      deviceUnreceived: deviceUnreceived ?? this.deviceUnreceived,
      timerLoading: timerLoading ?? this.timerLoading,
      hideDeviceActoiinsButtons:
          hideDeviceActoiinsButtons ?? this.hideDeviceActoiinsButtons,
    );
  }

  @override
  List<Object?> get props => [
        stateType,
        isLoading,
        timerLoading,
        loadingNote,
        noteAdded,
        unreceivingDevice,
        deviceUnreceived,
        duration,
        timerStatus,
        deviceDetails,
        hideDeviceActoiinsButtons,
      ];
}



class DeviceDetailsErrorState extends DeviceDetailsState {
  final TranslatableValue errorMessage;
  DeviceDetailsErrorState({
    required this.errorMessage,
  });
}

part of 'edit_device_bloc.dart';

class EditDeviceState extends Equatable {
  final DeviceDetails? deviceDetails;
  final bool isLoading;
  final bool editLoading;
  final double? uploadProgress;
  final bool editCompleted;
  final bool deviceCodeTaken;
  final bool deviceCodeCheckFailed;
  final bool checkDeviceCodeLoading;

  final List<DeviceType> deviceTypes;
  final List<Company> companies;

  EditDeviceState({
    this.deviceDetails,
    this.isLoading = false,
    this.editLoading = false,
    this.editCompleted = false,
    this.deviceCodeTaken = false,
    this.deviceCodeCheckFailed = false,
    this.checkDeviceCodeLoading = false,
    List<DeviceType>? deviceTypes,
    List<Company>? companies,
    this.uploadProgress,
  })  : this.companies = companies ?? [],
        this.deviceTypes = deviceTypes ?? [];

  EditDeviceState.initial()
      : this(
          isLoading: true,
          editLoading: false,
          editCompleted: false,
        );

  EditDeviceState copyWith({
    DeviceDetails? deviceDetails,
    bool? isLoading,
    List<DeviceType>? deviceTypes,
    List<Company>? companies,
    double? uploadProgress,
    bool? editLoading,
    bool? editCompleted,
    bool? deviceCodeTaken,
    bool? checkDeviceCodeLoading,
    bool? deviceCodeCheckFailed,
  }) =>
      EditDeviceState(
        deviceDetails: deviceDetails ?? this.deviceDetails,
        isLoading: isLoading ?? this.isLoading,
        companies: companies ?? this.companies,
        deviceTypes: deviceTypes ?? this.deviceTypes,
        uploadProgress: uploadProgress ?? this.uploadProgress,
        editLoading: editLoading ?? this.editLoading,
        editCompleted: editCompleted ?? this.editCompleted,
        checkDeviceCodeLoading:
            checkDeviceCodeLoading ?? this.checkDeviceCodeLoading,
        deviceCodeTaken: deviceCodeTaken ?? this.deviceCodeTaken,
        deviceCodeCheckFailed:
            deviceCodeCheckFailed ?? this.deviceCodeCheckFailed,
      );

  @override
  List<Object?> get props => [
        isLoading,
        editLoading,
        deviceDetails,
        deviceTypes,
        companies,
        uploadProgress,
        editCompleted,
        deviceCodeTaken,
        checkDeviceCodeLoading,
        deviceCodeCheckFailed,
      ];
}

class LoadDeviceDetailsError extends EditDeviceState {
  final TranslatableValue errorMessage;

  LoadDeviceDetailsError({required this.errorMessage});
}

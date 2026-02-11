part of 'add_device_bloc.dart';

class AddDeviceState extends Equatable {
  final Device device;
  final bool isLoading;
  final bool deviceCodeTaken;
  final bool deviceCodeCheckFailed;
  final bool checkDeviceCodeLoading;
  final String? codeFromEdit;
  final int deviceCheckCounter;

  final List<DeviceType> deviceTypes;
  final List<Company> companies;
  final TranslatableValue? errorStateMsg;
  final List<Collection>? collectionList;
  AddDeviceState({
    required this.device,
    this.isLoading = false,
    this.deviceCodeTaken = false,
    this.deviceCodeCheckFailed = false,
    this.checkDeviceCodeLoading = false,
    this.codeFromEdit,
    this.deviceCheckCounter = 0,
    List<DeviceType>? deviceTypes,
    List<Company>? companies,
    List<Collection>? collectionList,
    this.errorStateMsg,
  })  : this.companies = companies ?? [],
        this.deviceTypes = deviceTypes ?? [],
        this.collectionList = collectionList ?? [];

  AddDeviceState.initial({
    Device? device,
    List<Collection>? collectionList,
  }) : this(
            device: device ?? Device(images: [], qty: '1'),
            codeFromEdit: device?.deviceCode,
            isLoading: true,
            checkDeviceCodeLoading: false,
            deviceCodeTaken: false,
            collectionList: collectionList ?? []);

  AddDeviceState copyWith({
    Device? device,
    bool? isLoading,
    List<DeviceType>? deviceTypes,
    List<Company>? companies,
    TranslatableValue? errorStateMsg,
    bool removeErrorStateMsg = false,
    List<Collection>? collectionList,
    bool? deviceCodeTaken,
    bool? checkDeviceCodeLoading,
    bool? deviceCodeCheckFailed,
    String? codeFromEdit,
    int? deviceCheckCounter,
  }) {
    return AddDeviceState(
      device: device ?? this.device,
      isLoading: isLoading ?? this.isLoading,
      companies: companies ?? this.companies,
      deviceTypes: deviceTypes ?? this.deviceTypes,
      errorStateMsg:
          removeErrorStateMsg ? null : errorStateMsg ?? this.errorStateMsg,
      collectionList: collectionList ?? this.collectionList,
      checkDeviceCodeLoading:
          checkDeviceCodeLoading ?? this.checkDeviceCodeLoading,
      deviceCodeTaken: deviceCodeTaken ?? this.deviceCodeTaken,
      deviceCodeCheckFailed:
          deviceCodeCheckFailed ?? this.deviceCodeCheckFailed,
      codeFromEdit: codeFromEdit ?? this.codeFromEdit,
      deviceCheckCounter: deviceCheckCounter ?? this.deviceCheckCounter,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        device,
        deviceTypes,
        companies,
        errorStateMsg,
        collectionList,
        deviceCodeTaken,
        checkDeviceCodeLoading,
        codeFromEdit,
        deviceCheckCounter,
      ];
}

class DeviceSubmitted extends AddDeviceState {
  DeviceSubmitted({required super.device, super.isLoading});
}

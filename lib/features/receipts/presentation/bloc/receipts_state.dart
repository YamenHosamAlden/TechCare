part of 'receipts_bloc.dart';

final class ReceiptsState extends Equatable {
  final List<Receipt> receivedList;
  final List<Receipt> maintenanceList;
  final List<Receipt> qualityList;

  final bool loadingReceived;
  final bool loadingMaintenance;
  final bool loadingQuality;

  final bool loadingMoreReceived;
  final bool loadingMoreMaintenance;
  final bool loadingMoreQuality;

  final int? setPageIndex;

  // final TranslatableValue? errorMsg;

  const ReceiptsState({
    required this.receivedList,
    required this.maintenanceList,
    required this.qualityList,
    required this.loadingReceived,
    required this.loadingMaintenance,
    required this.loadingQuality,
    required this.loadingMoreReceived,
    required this.loadingMoreMaintenance,
    required this.loadingMoreQuality,
    this.setPageIndex,
    // this.errorMsg
  });

  ReceiptsState.initial()
      : this(
          receivedList: [],
          maintenanceList: [],
          qualityList: [],
          loadingReceived: false,
          loadingQuality: false,
          loadingMaintenance: false,
          loadingMoreReceived: false,
          loadingMoreMaintenance: false,
          loadingMoreQuality: false,
        );

  ReceiptsState copyWith({
    List<Receipt>? receivedList,
    List<Receipt>? maintenanceList,
    List<Receipt>? qualityList,
    bool? loadingReceived,
    bool? loadingMaintenance,
    bool? loadingQuality,
    bool? loadingMoreReceived,
    bool? loadingMoreMaintenance,
    bool? loadingMoreQuality,
    int? setPageIndex,
    // TranslatableValue? errorMsg,
  }) =>
      ReceiptsState(
        receivedList: receivedList ?? this.receivedList,
        maintenanceList: maintenanceList ?? this.maintenanceList,
        qualityList: qualityList ?? this.qualityList,
        loadingReceived: loadingReceived ?? this.loadingReceived,
        loadingMaintenance: loadingMaintenance ?? this.loadingMaintenance,
        loadingQuality: loadingQuality ?? this.loadingQuality,
        loadingMoreReceived: loadingMoreReceived ?? this.loadingMoreReceived,
        loadingMoreMaintenance:
            loadingMoreMaintenance ?? this.loadingMoreMaintenance,
        loadingMoreQuality: loadingMoreQuality ?? this.loadingMoreQuality,
        setPageIndex: setPageIndex,
        // errorMsg: errorMsg,
      );

  @override
  List<Object?> get props => [
        receivedList,
        maintenanceList,
        qualityList,
        receivedList.length,
        maintenanceList.length,
        qualityList.length,
        loadingReceived,
        loadingMaintenance,
        loadingQuality,
        loadingMoreReceived,
        loadingMoreMaintenance,
        loadingMoreQuality,
        // errorMsg,
      ];
}

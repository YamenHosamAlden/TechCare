part of 'maintenance_report_bloc.dart';

enum ItemsSource {
  WAREHOUSE,
  EXTERNAL,
}

final class MaintenanceReportState extends Equatable {
  final TextEditingController itemNumberField;
  final TextEditingController warehouseItemNameField;
  final TextEditingController externalItemNameField;
  final CounterController counterController;
  // final int counter;
  final ItemsSource? itemsSource;
  final MaintenanceReport maintenanceReport;
  final WarehouseItem? selectedWarehouseItem;

  final bool loadingSuggestions;
  final bool isloading;
  final bool reportCreated;

  MaintenanceReportState.initial()
      : this(
            // counter: 0,
            itemsSource: ItemsSource.WAREHOUSE,
            maintenanceReport:
                MaintenanceReport(installedItems: [], report: ''));

  MaintenanceReportState({
    this.loadingSuggestions = false,
    this.isloading = false,
    this.reportCreated = false,
    this.selectedWarehouseItem,
    this.itemsSource,
    required this.maintenanceReport,
    TextEditingController? itemNumberField,
    TextEditingController? warehouseItemNameField,
    TextEditingController? externalItemNameField,
    CounterController? counterController,
  })  : this.itemNumberField = itemNumberField ?? TextEditingController(),
        this.warehouseItemNameField =
            warehouseItemNameField ?? TextEditingController(),
        this.externalItemNameField =
            externalItemNameField ?? TextEditingController(),
        this.counterController =
            counterController ?? CounterController(initialValue: 0);

  MaintenanceReportState copyWith({
    int? counter,
    bool? counterErrorState,
    bool? isloading,
    bool? reportCreated,
    ItemsSource? itemsSource,
    MaintenanceReport? maintenanceReport,
    WarehouseItem? selectedWarehouseItem,
    bool removeSelectedItem = false,
  }) {
    return MaintenanceReportState(
      itemsSource: itemsSource ?? this.itemsSource,
      maintenanceReport: maintenanceReport ?? this.maintenanceReport,
      itemNumberField: this.itemNumberField,
      warehouseItemNameField: this.warehouseItemNameField,
      externalItemNameField: this.externalItemNameField,
      counterController: this.counterController,
      reportCreated: reportCreated ?? this.reportCreated,
      selectedWarehouseItem: removeSelectedItem
          ? null
          : selectedWarehouseItem ?? this.selectedWarehouseItem,
      isloading: isloading ?? this.isloading,
    );
  }

  @override
  List<Object?> get props => [
        itemsSource,
        maintenanceReport,
        selectedWarehouseItem,
        isloading,
        reportCreated,
      ];
}

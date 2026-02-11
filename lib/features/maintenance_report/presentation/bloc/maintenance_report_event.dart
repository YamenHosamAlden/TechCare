part of 'maintenance_report_bloc.dart';

abstract class MaintenanceReportEvent extends Equatable {
  const MaintenanceReportEvent();

  @override
  List<Object> get props => [];
}

class ChangeItemsSource extends MaintenanceReportEvent {
  final ItemsSource itemsSource;

  ChangeItemsSource({required this.itemsSource});
}

class IncrementCounter extends MaintenanceReportEvent {}

class DecrementCounter extends MaintenanceReportEvent {}

class ChangeReportText extends MaintenanceReportEvent {
  final String report;

  ChangeReportText({required this.report});
}

class SelectWarehouseItem extends MaintenanceReportEvent {
  final WarehouseItem item;

  SelectWarehouseItem({required this.item});
}

class AddItem extends MaintenanceReportEvent {
  AddItem();
}

class RemoveItem extends MaintenanceReportEvent {
  final int itemIndex;

  RemoveItem({required this.itemIndex});
}

class RemoveSelectedWarehouseItem extends MaintenanceReportEvent {}

class SubmitReport extends MaintenanceReportEvent {
  final int deviceId;
  SubmitReport({required this.deviceId});
}

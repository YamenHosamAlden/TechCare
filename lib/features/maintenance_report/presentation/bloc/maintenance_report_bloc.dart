import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/iinstalled_item.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/maintenance_report.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/warehouse_item.dart';
import 'package:tech_care_app/features/maintenance_report/domain/usecases/get_suggestied_items_usecase.dart';
import 'package:tech_care_app/features/maintenance_report/domain/usecases/submit_m_report_usecase.dart';
import 'package:tech_care_app/features/maintenance_report/presentation/widgets/counter_form_field.dart';

part 'maintenance_report_event.dart';
part 'maintenance_report_state.dart';

class MaintenanceReportBloc
    extends Bloc<MaintenanceReportEvent, MaintenanceReportState> {
  final GetSuggestedItemsUsecase getSuggestedItemsUsecase;
  final SubmitMReportUsecase submitMReportUsecase;

  MaintenanceReportBloc(
      {required this.getSuggestedItemsUsecase,
      required this.submitMReportUsecase})
      : super(MaintenanceReportState.initial()) {
    // on<IncrementCounter>(_onIncrementCounter);
    // on<DecrementCounter>(_onDecrementCounter);
    on<ChangeItemsSource>(_onChangeItemsSource);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ChangeReportText>(_onChangeReportText);
    on<SelectWarehouseItem>(_onSelectWarehouseItem);
    on<RemoveSelectedWarehouseItem>(_onRemoveSelectedWarehouseItem);
    on<SubmitReport>(_onSubmitReport);
  }

  @override
  Future<void> close() {
    state.itemNumberField.dispose();
    state.externalItemNameField.dispose();
    state.warehouseItemNameField.dispose();
    state.counterController.dispose();
    return super.close();
  }

  // FutureOr<void> _onIncrementCounter(
  //     IncrementCounter event, Emitter<MaintenanceReportState> emit) {
  //   // emit(state.copyWith(counter: state.counter + 1));
  // }

  // FutureOr<void> _onDecrementCounter(
  //     DecrementCounter event, Emitter<MaintenanceReportState> emit) {
  //   if (state.counter > 0) {
  //     emit(state.copyWith(counter: state.counter - 1));
  //   }
  // }

  FutureOr<void> _onChangeItemsSource(
      ChangeItemsSource event, Emitter<MaintenanceReportState> emit) {
    state.itemNumberField.text = '';
    state.warehouseItemNameField.text = '';
    state.externalItemNameField.text = '';
    emit(state.copyWith(
        counter: 0, itemsSource: event.itemsSource, removeSelectedItem: true));
  }

  FutureOr<void> _onAddItem(
      AddItem event, Emitter<MaintenanceReportState> emit) {
    if (state.counterController.counter <= 0) {
    } else {
      late final InstalledItem newItem;
      if (state.itemsSource == ItemsSource.EXTERNAL) {
        newItem = InstalledItem(
            itemName: state.externalItemNameField.text,
            qty: state.counterController.counter);
      } else if (state.itemsSource == ItemsSource.WAREHOUSE) {
        newItem = InstalledItem(
          id: state.selectedWarehouseItem!.id,
          itemNumber: state.selectedWarehouseItem!.itemNumber,
          itemName: state.selectedWarehouseItem!.itemName,
          qty: state.counterController.counter,
        );
      }
      final newMaintenanceReport = state.maintenanceReport.copyWith();
      newMaintenanceReport.installedItems.insert(0, newItem);

      emit(state.copyWith(
          counter: 0,
          maintenanceReport: newMaintenanceReport,
          removeSelectedItem: true));

      state.itemNumberField.text = '';
      state.warehouseItemNameField.text = '';
      state.externalItemNameField.text = '';
      state.counterController.counter = 0;
    }
  }

  FutureOr<void> _onRemoveItem(
      RemoveItem event, Emitter<MaintenanceReportState> emit) {
    final newMaintenanceReport = state.maintenanceReport.copyWith();
    newMaintenanceReport.installedItems.removeAt(event.itemIndex);
    emit(state.copyWith(maintenanceReport: newMaintenanceReport));
  }

  FutureOr<void> _onChangeReportText(
      ChangeReportText event, Emitter<MaintenanceReportState> emit) {
    emit(state.copyWith(
        maintenanceReport:
            state.maintenanceReport.copyWith(report: event.report)));
  }

  FutureOr<void> _onSelectWarehouseItem(
      SelectWarehouseItem event, Emitter<MaintenanceReportState> emit) {
    emit(state.copyWith(selectedWarehouseItem: event.item));
  }

  Future<List<WarehouseItem>> getSuggestedItems(
    int deviceId,
    String pattern,
  ) async {
    late final List<WarehouseItem> items;
    await getSuggestedItemsUsecase(Params(deviceId: deviceId, pattern: pattern))
        .then((value) {
      value.fold((l) => items = List.empty(),
          (warehouseItems) => items = warehouseItems);
    });
    return items;
  }

  FutureOr<void> _onRemoveSelectedWarehouseItem(
      RemoveSelectedWarehouseItem event, Emitter<MaintenanceReportState> emit) {
    if (state.selectedWarehouseItem != null) {
      emit(state.copyWith(removeSelectedItem: true));
    }
  }

  FutureOr<void> _onSubmitReport(
      SubmitReport event, Emitter<MaintenanceReportState> emit) async {
    emit(state.copyWith(isloading: true));
    await submitMReportUsecase(ReportParams(
            deviceId: event.deviceId,
            maintenanceReport: state.maintenanceReport))
        .then((value) => value.fold((failure) {
              emit(state.copyWith(isloading: false));
            }, (r) {
              print("emit reportCreated");
              emit(state.copyWith(reportCreated: true));
            }));
  }
}

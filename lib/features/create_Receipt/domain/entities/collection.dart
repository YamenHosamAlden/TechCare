import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/employee.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/maintenance_group.dart';

class Collection extends Equatable {
  final MaintenanceGroup? maintenanceGroup;
  final Employee? employee;
  final List<Device> devices;

  Collection({
    this.maintenanceGroup,
    this.employee,
    List<Device>? devices,
  }) : this.devices = devices ?? [];

  Collection copyWith({
    MaintenanceGroup? group,
    Employee? employee,
    List<Device>? devices,
    bool setEmployeeNull = false,
  }) =>
      Collection(
        maintenanceGroup: group ?? this.maintenanceGroup,
        employee: setEmployeeNull ? null : employee ?? this.employee,
        devices: devices ?? List.of(this.devices),
      );

  @override
  List<Object?> get props => [
        maintenanceGroup,
        employee,
        devices,
        devices.length,
      ];
}

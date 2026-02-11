import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/employee.dart';

class MaintenanceGroup extends Equatable {
  final int id;
  final String groupName;
  final List<Employee> employees;

  MaintenanceGroup(
      {required this.id, required this.groupName, required this.employees});

  MaintenanceGroup clone() =>
      MaintenanceGroup(id: id, groupName: groupName, employees: employees);

  @override
  List<Object?> get props => [id, groupName, employees];

  @override
  String toString() => groupName;
}

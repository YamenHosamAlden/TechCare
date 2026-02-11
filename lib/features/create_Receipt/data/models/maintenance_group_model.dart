import 'package:tech_care_app/features/create_receipt/data/models/employee_model.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/maintenance_group.dart';

class MaintenanceGroupModel extends MaintenanceGroup {
  final List<EmployeeModel> employees;
  MaintenanceGroupModel(
      {required super.id, required super.groupName, required this.employees})
      : super(employees: employees);

  MaintenanceGroupModel.fromEntity(MaintenanceGroup maintenanceGroup)
      : this(
          id: maintenanceGroup.id,
          groupName: maintenanceGroup.groupName,
          employees: [],
        );

  factory MaintenanceGroupModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceGroupModel(
      id: json['id'],
      groupName: json['name'],
      employees: (json['users'] as List)
          .map((userJson) => EmployeeModel.fromJson(userJson))
          .toList(),
    );
  }
}

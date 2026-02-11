import 'package:tech_care_app/features/create_receipt/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  EmployeeModel({required super.id, required super.name});

  EmployeeModel.fromEntity(Employee employee)
      : this(id: employee.id, name: employee.name);

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(id: json['id'], name: json['name']);
  }
}

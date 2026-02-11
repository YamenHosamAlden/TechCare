import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';

class CompanyModel extends Company {
  CompanyModel({required super.id, required super.name});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
    );
  }

  CompanyModel.fromEntity(Company company):this(id:company.id,name: company.name );
}

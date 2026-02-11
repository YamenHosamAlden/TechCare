import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';

class DeviceResources extends Equatable {
  final List<Company> companies;
  final List<DeviceType> types;

  DeviceResources({required this.companies, required this.types});

  @override
  List<Object?> get props => [companies, types];

  @override
  String toString() =>
      'AddDeviceResources (companies : ${companies.length} , types: ${types.length})';
}

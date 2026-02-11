import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';

class DeviceInfo extends Equatable {
  final int id;
  final String deviceCode;
  final String serialNumber;
  final String? qty;
  final DeviceType type;
  final String model;
  final String? assignName;
  final int? assignId;
   final TranslatableValue? status;
  final TranslatableValue? statusLable;

  DeviceInfo({
    required this.id,
    required this.deviceCode,
    required this.serialNumber,
    required this.qty,
    required this.type,
    required this.model,
    required this.assignName,
    required this.assignId,
    required this.status,
    required this.statusLable,
  });

  @override
  List<Object?> get props => [
        id,
        serialNumber,
        qty,
        type,
        model,
        assignId,
        assignName,
        status,
        statusLable
      ];
}

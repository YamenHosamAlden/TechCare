import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/used_item.dart';

class DeviceDeliveryReport extends Equatable {
  final int id;
  final String deviceCode;
  final bool isSalesReturn;
  final List<UsedItem> items;
  final String time;
  final String totalItemsCost;
  final String totalCost;
  final String totalOpeationalCost;
  final String fixedCost;

  final TranslatableValue warrantyType;

  DeviceDeliveryReport({
    required this.id,
    required this.deviceCode,
    required this.items,
    required this.totalItemsCost,
    required this.time,
    required this.isSalesReturn,
    required this.totalCost,
    required this.fixedCost,
    required this.warrantyType,
    required this.totalOpeationalCost,
  });

  DeviceDeliveryReport copyWith({
    int? id,
    String? deviceCode,
    bool? isSalesReturn,
    List<UsedItem>? items,
    String? time,
    String? totalItemsCost,
    String? totalCost,
    String? totalOpeationalCost,
    String? fixedCost,
    TranslatableValue? warrantyType,
  }) =>
      DeviceDeliveryReport(
        id: id ?? this.id,
        deviceCode: deviceCode ?? this.deviceCode,
        items: items ?? this.items,
        time: time ?? this.time,
        totalItemsCost: totalItemsCost ?? this.totalItemsCost,
        totalCost: totalCost ?? this.totalCost,
        totalOpeationalCost: totalOpeationalCost ?? this.totalOpeationalCost,
        fixedCost: fixedCost ?? this.fixedCost,
        isSalesReturn: isSalesReturn ?? this.isSalesReturn,
        warrantyType: warrantyType ?? this.warrantyType,
      );

  @override
  List<Object?> get props => [
        id,
        deviceCode,
        items,
        time,
        totalCost,
        fixedCost,
        totalItemsCost,
        isSalesReturn,
        warrantyType,
        totalOpeationalCost,
      ];
}

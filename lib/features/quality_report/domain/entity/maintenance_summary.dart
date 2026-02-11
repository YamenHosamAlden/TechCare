import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/used_item.dart';

class MaintenanceSummary extends Equatable {
  final int id;
  final TranslatableValue warrantyType;
  final String totalItemsCost;
  final String totalOpeationalCost;
  final String totalCost;
  final String time;
  final List<UsedItem> items;

  MaintenanceSummary({
    required this.id,
    required this.items,
    required this.totalItemsCost,
    required this.time,
    required this.totalCost,
    required this.warrantyType,
    required this.totalOpeationalCost,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        time,
        totalCost,
        totalItemsCost,
        warrantyType,
        totalOpeationalCost,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/used_item.dart';

class DevicePaymentDetails extends Equatable {
  final String deviceCode;
  final String totalTime;
  final String itemsCost;
  final String operationalCost;
  final String totalCost;
  final String paidAmount;
  final List<UsedItem> usedItem;

  DevicePaymentDetails({
    required this.deviceCode,
    required this.totalTime,
    required this.itemsCost,
    required this.operationalCost,
    required this.totalCost,
    required this.paidAmount,
    required this.usedItem,
  });

  @override
  List<Object?> get props => [
        deviceCode,
        totalTime,
        usedItem,
        itemsCost,
        operationalCost,
        totalCost,
        paidAmount,
      ];
}

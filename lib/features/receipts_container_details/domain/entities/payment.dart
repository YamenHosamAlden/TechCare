import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_reference.dart';

class Payment extends Equatable {
  final String amount;
  final DateTime date;
  final String expectedCost;
  final String? note;
  final List<DeviceReference> devices;

  Payment(
      {required this.amount,
      required this.date,
      required this.expectedCost,
      required this.note,
      required this.devices});

  @override
  List<Object?> get props => [
        amount,
        date,
        expectedCost,
        note,
        devices,
      ];
}

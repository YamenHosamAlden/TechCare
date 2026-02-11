import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';

class ReceiptContainer extends Equatable {
  final int id;
  final String customerName;
  final String receiptNumber;
  final String customerPhone;
  final TranslatableValue priority;
  final String? priorityShippingNumber;
  final DateTime date;

  ReceiptContainer({
    required this.id,
    required this.receiptNumber,
    required this.customerName,
    required this.customerPhone,
    required this.priority,
    required this.priorityShippingNumber,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        customerName,
        customerPhone,
        priority,
        priority,
        priorityShippingNumber,
        date,
      ];
}

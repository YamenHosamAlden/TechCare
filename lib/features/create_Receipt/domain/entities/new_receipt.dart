import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';

class NewReceipt extends Equatable {
  final String? customerName;
  final String? customerPhone;
  final TranslatableValue? priority;
  final String? shippingNumber;
  final List<Collection> collections;

  NewReceipt({
    required this.customerName,
    required this.customerPhone,
    required this.priority,
    required this.shippingNumber,
    required this.collections,
  });

  @override
  List<Object?> get props => [
        customerName,
        customerPhone,
        priority,
        shippingNumber,
        collections,
        collections.length
      ];
}

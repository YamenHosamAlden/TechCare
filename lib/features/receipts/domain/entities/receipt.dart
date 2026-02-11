import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';

class Receipt extends Equatable {
  final int id;
  final String receiptNumber;
  final int groupId;
  final String groupName;
  final TranslatableValue priority;
  final String customerName;
  final String customerPhoneNumber;
  final int? userId;
  final DateTime createdAt;
  final bool hasReturnedDevice;

  const Receipt({
    required this.id,
    required this.receiptNumber,
    required this.groupId,
    required this.groupName,
    required this.priority,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.hasReturnedDevice,
    this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        groupId,
        userId,
        hasReturnedDevice,
        createdAt,
      ];
}

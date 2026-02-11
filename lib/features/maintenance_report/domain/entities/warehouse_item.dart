import 'package:equatable/equatable.dart';

class WarehouseItem extends Equatable {
  final id;
  final String itemNumber;
  final String itemName;
  WarehouseItem({
    required this.id,
    required this.itemNumber,
    required this.itemName,
  });

  @override
  List<Object?> get props => [
        id,
        itemNumber,
        itemName,
      ];
}

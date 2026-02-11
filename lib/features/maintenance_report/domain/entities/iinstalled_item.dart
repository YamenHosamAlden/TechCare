import 'package:equatable/equatable.dart';

class InstalledItem extends Equatable {
  final int? id;
  final String? itemNumber;
  final String itemName;
  final int qty;

  InstalledItem({
    this.id,
    this.itemNumber,
    required this.itemName,
    required this.qty,
  });

  @override
  List<Object?> get props => [
        id,
        itemNumber,
        itemName,
        qty,
      ];
}

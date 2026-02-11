import 'package:equatable/equatable.dart';

class MaintenanceItem extends Equatable {
  final String? number;
  final String name;
  final int qty;

  MaintenanceItem({
    required this.number,
    required this.name,
    required this.qty,
});

  @override
  List<Object?> get props => [
        number,
        name,
        qty,
      ];
}

import 'package:equatable/equatable.dart';

class UsedItem extends Equatable {
  final int id;
  final String? name;
  final String price;
  final String cost;
  final int qty;

  UsedItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.cost,
      required this.qty,});

  @override
  List<Object?> get props => [];
}

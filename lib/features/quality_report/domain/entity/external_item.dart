import 'package:equatable/equatable.dart';

class ExternalItem extends Equatable {
  final int id;
  final String name;
  final double? price;

  ExternalItem({required this.id, required this.name, this.price});

  ExternalItem copyWith({
    String? name,
    double? price,
  }) =>
      ExternalItem(
        id: id,
        name: name ?? this.name,
        price: price ?? this.price,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        price,
      ];
}

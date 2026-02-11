import 'package:equatable/equatable.dart';

class GroupUser extends Equatable {
  final int id;
  final String name;

  const GroupUser({required this.id, required this.name});

  @override
  List<Object?> get props => [
        id,
        name,
      ];

  @override
  String toString() {
    return name;
  }
}

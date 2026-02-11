import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final String name;

  Employee({required this.id, required this.name});
  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => name;
}

import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final int id;
  final String name;

  Company({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => name;
}

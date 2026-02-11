import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/auth/domain/entities/permission_handler.dart';

class User extends Equatable {
  final int id;
  final int branchId;
  final String name;
  final String branchName;
  final String? img;
  final String role;
  final PermissionHandler? permission;

  User({
    required this.id,
    required this.branchId,
    required this.name,
    required this.branchName,
    required this.img,
    required this.role,
    this.permission,
  });

 

  @override
  List<Object?> get props => [
        id,
        branchId,
        name,
        name,
        branchName,
        role,
        img,
        permission,
      ];
}

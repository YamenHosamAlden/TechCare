import 'package:tech_care_app/features/auth/data/models/permission_handler_model.dart';
import 'package:tech_care_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  final PermissionHandlerModel? permissions;
  UserModel({
    required super.id,
    required super.branchId,
    required super.name,
    required super.branchName,
    required super.img,
    required super.role,
    this.permissions,
  }) : super(permission: permissions);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userJson = json['user'];
    return UserModel(
        id: userJson['id'],
        branchId: userJson['branch_id'],
        name: userJson['name'],
        branchName: userJson['branch'],
        img: userJson['img'],
        role: (json['roles'] as List).first,
        permissions: PermissionHandlerModel.fromJson(json));
  }
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'role': this.role,
    };
  }
}

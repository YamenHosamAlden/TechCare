import 'package:tech_care_app/features/auth/domain/entities/permission_handler.dart';

class PermissionHandlerModel extends PermissionHandler {
  PermissionHandlerModel({
    required super.permissions,
  });

  factory PermissionHandlerModel.fromJson(Map<String, dynamic> json) =>
      PermissionHandlerModel(permissions:{"admin","user1"} );
}

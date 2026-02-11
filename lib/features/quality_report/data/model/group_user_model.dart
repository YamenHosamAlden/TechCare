import 'package:tech_care_app/features/quality_report/domain/entity/group_user.dart';

class GroupUserModel extends GroupUser {
  GroupUserModel({
    required super.id,
    required super.name,
  });

  factory GroupUserModel.fromJson(Map<String, dynamic> json) {
    return GroupUserModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory GroupUserModel.fromEntity(GroupUser user) {
    return GroupUserModel(
      id: user.id,
      name: user.name,
    );
  }
}

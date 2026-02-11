import 'package:tech_care_app/core/models/translatable_value_model.dart';
import 'package:tech_care_app/features/app_launch/domain/entity/version_status.dart';

class VersionStatusModel extends VersionStatus {
  final TranslatableValueModel description;
  VersionStatusModel({
    required super.appVersion,
    required super.appStatus,
    required super.apiVersion,
    required super.apiStatus,
    required super.newAppVersion,
    required this.description,
    required super.platform,
    required super.storeUrl,
    required super.directUrl,
  }) : super(description: description);

  factory VersionStatusModel.fromJson(Map<String, dynamic> json) {
    return VersionStatusModel(
      appVersion: json['appVersion'],
      appStatus: AppStatus.formString(json['appStatus']),
      apiVersion: json['apiVersion'],
      apiStatus: ApiStatus.formString(json['apiStatus']),
      newAppVersion: json['newAppVersion'],
      description:
          TranslatableValueModel.fromJson(key: 'description', json: json),
      platform: AppPlatform.formString(json['platform']),
      storeUrl: json['storeUrl'],
      directUrl: json['directUrl'],
    );
  }
}

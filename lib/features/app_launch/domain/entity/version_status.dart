import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';

class VersionStatus extends Equatable {
  final String appVersion;
  final AppStatus appStatus;
  final String apiVersion;
  final ApiStatus apiStatus;
  final String newAppVersion;
  final TranslatableValue description;
  final AppPlatform platform;
  final String storeUrl;
  final String directUrl;

  VersionStatus({
    required this.appVersion,
    required this.appStatus,
    required this.apiVersion,
    required this.apiStatus,
    required this.newAppVersion,
    required this.description,
    required this.platform,
    required this.storeUrl,
    required this.directUrl,
  });

  @override
  List<Object?> get props => [
        appVersion,
        appStatus,
        apiVersion,
        apiStatus,
        newAppVersion,
        description,
        platform,
        storeUrl,
        directUrl,
      ];
}

enum AppStatus {
  NONE,
  NEW_UPDATE,
  REQUIRED_UPDATE;

  static AppStatus formString(String status) {
    switch (status) {
      case 'none':
        return AppStatus.NONE;
      case 'new':
        return AppStatus.NEW_UPDATE;
      case 'required':
        return AppStatus.REQUIRED_UPDATE;
    }
    return AppStatus.NONE;
  }
}

enum ApiStatus {
  UP,
  DOWN;

  static ApiStatus formString(String status) {
    switch (status) {
      case 'up':
        return ApiStatus.UP;
      case 'down':
        return ApiStatus.DOWN;
    }
    return ApiStatus.DOWN;
  }
}

enum AppPlatform {
  ANDROID,
  IOS;

  static AppPlatform formString(String? platform) {
    switch (platform?.toUpperCase()) {
      case 'ANDROID':
        return AppPlatform.ANDROID;
      case 'IOS':
        return AppPlatform.IOS;
    }
    return AppPlatform.ANDROID;
  }
}

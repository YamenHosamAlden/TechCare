import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/features/app_launch/data/model/version_status_model.dart';

abstract class AppLaunchRemoteDataSource {
  Future<VersionStatusModel> getAppStatus();
}

class AppLaunchRemoteDataSourceImpl implements AppLaunchRemoteDataSource {
  final Dio dio;

  AppLaunchRemoteDataSourceImpl({required this.dio});

  String get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<VersionStatusModel> getAppStatus() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final res = await dio.post(baseUrl + 'version', data: {
      'version': packageInfo.version,
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
      // 'api': null,
    });
    // print(res.statusCode);
    // print(res.data);
    return VersionStatusModel.fromJson(res.data['data']);

  }
}

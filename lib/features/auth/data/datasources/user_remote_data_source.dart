import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/auth/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> get user;
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  get baseUrl => ServerConfig().authServerAddress;

  @override
  Future<UserModel> get user async {
    final response = await dio.get(
      baseUrl + 'getUser',
    );
    if (response.statusCode == 200) {
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}

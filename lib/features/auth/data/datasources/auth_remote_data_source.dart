import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/models/translatable_value_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String userName, String passWord);
  Future<void> logout();
  Future<void> validateToken(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  String get baseUrl => ServerConfig().authServerAddress;

  @override
  Future<String> login(String userName, String passWord) async {
    final response = await dio.post(
      baseUrl + 'appLogin',
      data: FormData.fromMap(
        {
          "username": userName,
          "password": passWord,
        },
      ),
    );

    if (response.statusCode == 200) {
      if (response.data['success'] == true) {
        return (response.data['data']['token']);
      } else {
        throw LoginExcption(
          msg: TranslatableValueModel.fromJson(
            key: 'message',
            json: response.data,
          ),
        );
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> validateToken(String token) async {
    dio.options.headers['Authorization'] = "Berear $token";
    final response = await dio.get(baseUrl + 'getUser');

    if (response.statusCode == 200) {
      if (response.data['success'] == true) {
        return;
      } else {
        throw UnauthenticatedException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    final response = await dio.post(
      baseUrl + 'logout',
    );

    if (response.statusCode == 200) {
      return;
    }
    throw ServerException();
  }
}

import 'package:tech_care_app/core/models/translatable_value_model.dart';

class ServerException implements Exception {}

class CacheException implements Exception {}
class NotFoundException implements Exception {}
class LoginExcption implements Exception {
  TranslatableValueModel msg;
  LoginExcption({required this.msg});
}

class UnauthenticatedException implements Exception {}


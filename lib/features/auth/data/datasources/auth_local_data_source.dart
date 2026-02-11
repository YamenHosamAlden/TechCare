import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_care_app/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String Token);

  Future<void> deleteCachedToken();

  Future<String> getCachedToken();
}

const String CACHED_TOKEN = 'cached_token';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) {
    return sharedPreferences.setString(CACHED_TOKEN, token);
  }

  @override
  Future<void> deleteCachedToken() {
    return sharedPreferences.remove(CACHED_TOKEN);
  }

  @override
  Future<String> getCachedToken() {
    final token = sharedPreferences.getString(CACHED_TOKEN);
    if (token != null) {
      return Future<String>.value(token);
    } else {
      throw CacheException();
    }
  }
}

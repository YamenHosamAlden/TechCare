import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ServerConfig {
  static ServerConfig? _instance;

  static late String _authServerAddress;
  static late String _warehouseServerAddress;
  static late String _maintenanceServerAddress;

  static Future<void> init() async {
    await _loadConfig();
  }

  ServerConfig._();

  factory ServerConfig() {
    if (_instance == null) {
      throw Exception("server configuration is not initialized");
    }
    return _instance!;
  }

  String get authServerAddress => _authServerAddress;

  String get warehouseServerAddress => _warehouseServerAddress;

  String get maintenanceServerAddress => _maintenanceServerAddress;

  static Future<void> _loadConfig() async {
    try {
      final String response =
          await rootBundle.loadString('assets/config/server_config.json');
      final data = jsonDecode(response);
      _authServerAddress = data['authServerAddress'];
      _warehouseServerAddress = data['warehouseServerAddress'];
      _maintenanceServerAddress = data['maintenanceServerAddress'];
      _instance = ServerConfig._();
    } catch (e) {
      throw Exception("Failed to load server configuration: ${e.toString()}");
    }
  }
}

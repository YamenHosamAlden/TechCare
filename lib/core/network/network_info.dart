import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection internetConnection;

  NetworkInfoImpl(this.internetConnection);

  @override
  Future<bool> get isConnected async {
    bool connection = false;
    for (int i = 0; i < 25; i++) {
      print('\x1B[33m$i\x1B[0m'); 
      connection = await internetConnection.hasInternetAccess;
      if (connection) {
        break;
      }
    }
    return connection;
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';

class Network {
  static Future<bool> check() async {
    var result = await Connectivity().checkConnectivity();

    // check if user is connected to the internet or not
    return result != ConnectivityResult.none;
  }
}

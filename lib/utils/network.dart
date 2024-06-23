// ignore_for_file: avoid_print, unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';

class Network {
  static Future<bool> check() async {
    try {
      var result = await Connectivity().checkConnectivity();

      return result != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }
}

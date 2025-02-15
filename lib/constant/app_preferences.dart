import 'package:nb_utils/nb_utils.dart';

class AppPreferences {
  /*  Set user id  */
  static Future<void> setUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', userId);
  }

  /* set adminId */
  static Future<void> setAdminId(int adminId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('adminId', adminId);
  }

  /* set gpc */
  static Future<void> setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  /* set member category description */
  static Future<void> setName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  /* set token */
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  /* set imei */
  static Future<void> setImei(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imei', token);
  }

  // set Scan Location
  static Future<void> setScanLocation(int scanLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('scanLocation', scanLocation);
  }

  // Getters

  /*  Get user id  */
  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  /* get adminId */
  static Future<int?> getAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('adminId');
  }

  /* get email */
  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  /* get name */
  static Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  /* get token */
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /* get imei */
  static Future<String?> getImei() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('imei');
  }

  // get Scan Location
  static Future<int?> getScanLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('scanLocation');
  }
}

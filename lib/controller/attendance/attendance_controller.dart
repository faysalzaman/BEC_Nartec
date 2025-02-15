// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bec_app/constant/app_preferences.dart';
import 'package:bec_app/constant/app_urls.dart';
import 'package:bec_app/model/attendance/AttendanceModel.dart';
import 'package:bec_app/model/attendance/ImeiModel.dart';
import 'package:bec_app/model/attendance/WpsModel.dart';
import 'package:bec_app/model/attendance/locationModel.dart';
import 'package:http/http.dart' as http;

class AttendanceController {
  static Future<ImeiModel> attendanceIn(
      String id, String action, String? wps, String? costCode) async {
    String? token = await AppPreferences.getToken();
    String? deviceId = await AppPreferences.getImei();

    int? adminId = await AppPreferences.getUserId();
    int? locationId = await AppPreferences.getScanLocation();

    final url = Uri.parse('${AppUrls.baseUrl}/api/attendance');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String date = DateTime.now().toString();

    final body = wps == null && costCode == null
        ? jsonEncode({
            "employeeId": id,
            "timestamp": date,
            "IMEI": deviceId,
            "action": action,
            "adminId": adminId,
            "locationId": locationId
          })
        : jsonEncode({
            "employeeId": id,
            "timestamp": date,
            "IMEI": deviceId,
            "action": action,
            "wps": wps,
            "costCode": costCode,
            "adminId": adminId,
            "locationId": locationId
          });

    final response = await http.post(url, headers: headers, body: body);

    var data = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ImeiModel.fromJson(data);
    } else {
      final msg = data['message'];
      print(msg);
      throw Exception(msg);
    }
  }

  static Future<List<AttendanceModel>> getAttendance(String id) async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrl}/api/attendance/$id');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    var info = json.decode(response.body)['attendanceRecords'] as List;

    if (response.statusCode == 200 || response.statusCode == 201) {
      return info.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }

  // get costCode
  static Future<List<WpsModel>> getCostCode() async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/costCodes');

    final response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var info = json.decode(response.body)['costCodes'] as List;

      return info.map((e) => WpsModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }

  // get wps
  static Future<List<WpsModel>> getWps(int locationId) async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/wps?locationId=$locationId');

    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var info = json.decode(response.body)['wps'] as List;
      return info.map((e) => WpsModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }

  // get location
  static Future<List<LocationModel>> getLocation() async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/location');

    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var info = json.decode(response.body)['locations'] as List;
      return info.map((e) => LocationModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }
}

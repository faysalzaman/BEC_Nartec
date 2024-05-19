// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bec_app/global/constant/app_preferences.dart';
import 'package:bec_app/global/constant/app_urls.dart';
import 'package:bec_app/model/attendance/AttendanceModel.dart';
import 'package:http/http.dart' as http;

class AttendanceController {
  static Future<void> attendanceIn(String id) async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrl}/api/attendance/checkin');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String date = DateTime.now().toString();

    final body = jsonEncode({"employeeId": id, "checkIn": date});

    final response = await http.post(url, headers: headers, body: body);

    print(response.body);

    if (response.statusCode == 200) {
      return;
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }

  static Future<void> attendanceOut(String id) async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrl}/api/attendance/checkout');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String date = DateTime.now().toString();

    final body = jsonEncode({"employeeId": id, "checkOut": date});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return;
    } else {
      final msg = json.decode(response.body)['error'];
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
}

import 'dart:convert';

import 'package:bec_app/constant/app_preferences.dart';
import 'package:bec_app/constant/app_urls.dart';
import 'package:bec_app/model/attendance/ImeiModel2.dart';
import 'package:http/http.dart' as http;

class TransactionController {
  static Future<ImeiModel2> transaction(String empId) async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/transactions');

    String? token = await AppPreferences.getToken();
    String? deviceId = await AppPreferences.getImei();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // 2024-05-18 this format
    String date = DateTime.now().toString().substring(0, 10);

    final body = jsonEncode({'employeeId': empId, 'date': date, "IMEI": deviceId});

    final response = await http.post(url, headers: headers, body: body);

    var data = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ImeiModel2.fromJson(data);
    } else {
      final msg = data['error'];
      throw Exception(msg);
    }
  }
}

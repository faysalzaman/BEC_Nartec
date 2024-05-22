import 'dart:convert';

import 'package:bec_app/constant/app_preferences.dart';
import 'package:bec_app/constant/app_urls.dart';
import 'package:http/http.dart' as http;

class TransactionController {
  static Future<void> transaction(
    String empId,
    String mealType,
  ) async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/transactions');

    String? token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // 2024-05-18 this format
    String date = DateTime.now().toString().substring(0, 10);

    final body =
        jsonEncode({'employeeId': empId, 'date': date, 'mealType': mealType});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }
}

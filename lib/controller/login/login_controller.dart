// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bec_app/constant/app_urls.dart';
import 'package:bec_app/model/login/LoginModel.dart';
import 'package:http/http.dart' as http;

class AuthController {
  static Future<LoginModel> login(String email, String password) async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/admin/login');
    final headers = <String, String>{'Content-Type': 'application/json'};

    final body = json.encode({'userId': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    var data = LoginModel.fromJson(json.decode(response.body));
    print(data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }
}

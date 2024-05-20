import 'dart:convert';
import 'package:bec_app/global/constant/app_preferences.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:bec_app/global/constant/app_urls.dart';
import 'package:http/http.dart' as http;

class EmployeeController {
  static Future<List<EmployeeModel>> getEmployee(int page, int pageSize) async {
    final url = Uri.parse(
        '${AppUrls.baseUrl}/api/employee/data/getpaginatedEmployees?page=$page&pageSize=$pageSize&sortOrder=desc');

    String? token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    var info = json.decode(response.body)['employees'] as List;

    if (response.statusCode == 200 || response.statusCode == 201) {
      return info.map((e) => EmployeeModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }

  // load more
  static Future<List<EmployeeModel>> getEmployeeLoadMore(
      int page, int pageSize) async {
    final url = Uri.parse(
        '${AppUrls.baseUrl}/api/employee/data/getpaginatedEmployees?page=$page&pageSize=$pageSize&sortOrder=desc');

    String? token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    var info = json.decode(response.body)['employees'] as List;

    if (response.statusCode == 200 || response.statusCode == 201) {
      return info.map((e) => EmployeeModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }

  static Future<List<EmployeeModel>> searchEmployee(String keyword) async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/employee/search/$keyword');

    String? token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    var info = json.decode(response.body) as List;

    if (response.statusCode == 200 || response.statusCode == 201) {
      return info.map((e) => EmployeeModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }

  static Future<EmployeeModel> getEmployeeById(String id) async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrl}/api/employee/$id');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    var info = json.decode(response.body)['employee'];

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmployeeModel.fromJson(info);
    } else {
      final msg = json.decode(response.body)['error'];
      throw Exception(msg);
    }
  }
}

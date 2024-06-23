import 'dart:io';

import 'package:bec_app/constant/app_preferences.dart';
import 'package:bec_app/constant/app_urls.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class OfflineController {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFileAttendance async {
    final path = await _localPath;
    return File('$path/attendance.json');
  }

  static Future<File> get _localFileTransaction async {
    final path = await _localPath;
    return File('$path/transaction.json');
  }

  static Future<List<dynamic>> readJsonFileTransaction() async {
    try {
      final file = await _localFileTransaction;

      // Read the file
      String contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      // If encountering an error, return an empty list
      return [];
    }
  }

  static Future<List<dynamic>> readJsonFileAttendance() async {
    try {
      final file = await _localFileAttendance;

      // Read the file
      String contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      // If encountering an error, return an empty list
      return [];
    }
  }

  static Future<void> transferAttendanceToDatabase() async {
    final url =
        Uri.parse('${AppUrls.baseUrl}/api/attendance/createBulkAttendances');

    String? token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var attendanceList = await readJsonFileAttendance();

    final body = {"attendances": attendanceList};

    print(jsonEncode(body));

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    var data = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Attendancing Syncing Successful");
      return;
    } else {
      final msg = data['error'];
      throw Exception(msg);
    }
  }

  static Future<void> transferTransactionToDatabase() async {
    final url = Uri.parse('${AppUrls.baseUrl}/api/transactions/bulkImport');

    String? token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var transactionList = await readJsonFileTransaction();

    final body = {"transactions": transactionList};
    print(jsonEncode(body));

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    var data = json.decode(response.body);

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Transaction Syncing Successful");
      return;
    } else {
      final msg = data['error'];
      throw Exception(msg);
    }
  }
}

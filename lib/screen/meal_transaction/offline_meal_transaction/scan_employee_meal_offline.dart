import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/constant/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class LocalStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/transactions.json');
  }

  Future<File> writeTransactions(List<Map<String, dynamic>> data) async {
    final file = await _localFile;
    return file.writeAsString(json.encode(data));
  }

  Future<List<Map<String, dynamic>>> readTransactions() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return List<Map<String, dynamic>>.from(json.decode(contents));
      }
      return [];
    } catch (e) {
      print('Error reading transactions: $e');
      return [];
    }
  }

  Future<int> getTodayTransactionsCount() async {
    final transactions = await readTransactions();
    final today = DateTime.now();
    final todayTransactions = transactions.where((transaction) {
      final date = DateTime.parse(transaction['date']);
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();
    return todayTransactions.length;
  }
}


class ScanEmployeeMealOfflineScreen extends StatefulWidget {
  const ScanEmployeeMealOfflineScreen({super.key});

  @override
  State<ScanEmployeeMealOfflineScreen> createState() =>
      _ScanEmployeeMealOfflineScreenState();
}

class _ScanEmployeeMealOfflineScreenState
    extends State<ScanEmployeeMealOfflineScreen> {
  TextEditingController qrTextController = TextEditingController();
  FocusNode qrTextFocus = FocusNode();

  @override
  void dispose() {
    qrTextController.dispose();
    qrTextFocus.dispose();
    super.dispose();
  }

  Future<void> syncTransactions() async {
    final localStorage = LocalStorage();
    final transactions = await localStorage.readTransactions();

    if (transactions.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/transactions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(transactions),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        print('Data synced successfully');
        // Optionally clear local storage
        await localStorage.writeTransactions([]);
      } else {
        // Handle error
        print('Failed to sync data');
      }
    } else {
      print('No transactions to sync');
    }
  }


  Future<void> addTransaction(BuildContext context, String employeeCode) async {
    final localStorage = LocalStorage();
    final todayTransactionsCount = await localStorage.getTodayTransactionsCount();

    if (todayTransactionsCount >= 3) {
      // Show a message that the user has already taken all meals for today
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have taken all your meals for today')),
      );
      return;
    }

    String? token = await AppPreferences.getToken();  // Assuming this is defined in AppPreferences
    String? deviceId = await AppPreferences.getImei(); // Assuming this is defined in AppPreferences

    final transactions = await localStorage.readTransactions();

    transactions.add({
      'employeeCode': employeeCode,
      'date': DateTime.now().toIso8601String(),
      'IMEI': deviceId
    });

    await localStorage.writeTransactions(transactions);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction added successfully')),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logos/bec_logo.jpeg',
                  width: context.width() * 0.3,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/qr_code.png',
                  width: context.width() * 0.2,
                  height: context.height() * 0.1,
                ),
              ),
              20.height,
              const Text(
                "Scan the Employee's QR Code",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              20.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: qrTextController,
                  focusNode: qrTextFocus,
                  onEditingComplete: () async {
                    await addTransaction(context, qrTextController.text.trim());
                    // Perform any additional actions or UI updates here
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    hintText: 'Scan the QR Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              40.height,
              SizedBox(
                width: context.width() * 0.6,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await addTransaction(context, qrTextController.text.trim());
                    // Perform any additional actions or UI updates here
                  },
                  child: const Text(
                    'Search',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

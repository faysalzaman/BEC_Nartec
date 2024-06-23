// ignore_for_file: avoid_print

import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/constant/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import "dart:developer" as dev;

class ScanEmployeeAttendaceOfflineScreen extends StatefulWidget {
  const ScanEmployeeAttendaceOfflineScreen({super.key});

  @override
  State<ScanEmployeeAttendaceOfflineScreen> createState() =>
      _ScanEmployeeAttendaceOfflineScreenState();
}

class _ScanEmployeeAttendaceOfflineScreenState
    extends State<ScanEmployeeAttendaceOfflineScreen> {
  TextEditingController qrTextController = TextEditingController();
  FocusNode qrTextFocus = FocusNode();

  @override
  void dispose() {
    qrTextController.dispose();
    qrTextFocus.dispose();
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/attendance.json');
  }

  Future<List<dynamic>> readJsonFile() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      // If encountering an error, return an empty list
      return [];
    }
  }

  Future<void> writeJsonFile(Map<String, dynamic> jsonData) async {
    try {
      final file = await _localFile;

      List<dynamic> jsonList = [];

      if (await file.exists()) {
        // Read the existing file
        String contents = await file.readAsString();
        if (contents.isNotEmpty) {
          var jsonData = json.decode(contents);
          if (jsonData is List) {
            jsonList = jsonData;
          }
        }
      }

      // Append the new data to the list
      jsonList.add(jsonData);

      // Write the updated list back to the file
      await file.writeAsString(json.encode(jsonList));

      // Display success toast message
      toast("Check-in/out Successful");
    } catch (e) {
      print(e);
    }
  }

  Future<void> clearJsonFile() async {
    try {
      final file = await _localFile;

      // Write an empty list to the file to clear its contents
      await file.writeAsString(json.encode([]));

      // Display success toast message
      print("File Cleared");
    } catch (e) {
      print(e);
    }
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
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                color: Colors.redAccent[100],
                child: const Text(
                  'You are in Offline Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Column(
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
                      onEditingComplete: onSubmit,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                      // onPressed: () async {
                      //   var data = await readJsonFile();
                      //   dev.log(jsonEncode(data));
                      // },
                      onPressed: onSubmit,
                      child: const Text(
                        'Search',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit() async {
    qrTextFocus.unfocus();

    if (qrTextController.text.isEmpty) {
      qrTextFocus.unfocus();
      return;
    }

    String currentDate = DateTime.now().toIso8601String();
    String? deviceId = await AppPreferences.getImei();

    await writeJsonFile(<String, dynamic>{
      'employeeCode': qrTextController.text.trim(),
      'timestamp': currentDate,
      'IMEI': deviceId
    });

    var data = await readJsonFile();
    dev.log(jsonEncode(data));

    qrTextController.clear();
  }
}

// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:bec_app/cubit/offline_cubit/offline_cubit.dart';
import 'package:bec_app/cubit/offline_cubit/offline_state.dart';
import 'package:bec_app/screen/home/offline_home_screen.dart';
import 'package:bec_app/screen/login/login_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:bec_app/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

class ModeSelectionScreen extends StatelessWidget {
  ModeSelectionScreen({super.key});

  final OfflineCubit offlineCubit = OfflineCubit();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileAttendance async {
    final path = await _localPath;
    return File('$path/attendance.json');
  }

  Future<File> get _localFileTransaction async {
    final path = await _localPath;
    return File('$path/transaction.json');
  }

  Future<List<dynamic>> readJsonFileTransaction() async {
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

  Future<List<dynamic>> readJsonFileAttendance() async {
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

  Future<void> clearAttendanceFile() async {
    try {
      final file = await _localFileAttendance;

      // Write an empty list to the file to clear its contents
      await file.writeAsString(json.encode([]));

      // Display success toast message
      print("File Cleared");
    } catch (e) {
      print(e);
    }
  }

  Future<void> clearTransactionFile() async {
    try {
      final file = await _localFileTransaction;

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlueAccent,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Choose Your Mode',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Select online mode for real-time data or offline mode for local data.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                  onPressed: () async {
                    bool networkStatus = await Network.check();
                    print(networkStatus);
                    if (!networkStatus) {
                      toast("You cannot go online without internet connection");
                      return;
                    } else {
                      AppNavigator.goToPage(
                        context: context,
                        screen: const LoginScreen(),
                      );
                    }
                  },
                  child: const Text('ONLINE MODE'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  onPressed: () {
                    AppNavigator.goToPage(
                      context: context,
                      screen: const OfflineHomeScreen(),
                    );
                  },
                  child: const Text('OFFLINE MODE'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocConsumer<OfflineCubit, OfflineState>(
              bloc: offlineCubit,
              listener: (context, state) async {
                if (state is OfflineLoaded) {
                  await clearTransactionFile();
                  await clearAttendanceFile();
                  toast("Syncing Completed");
                }
                if (state is OfflineError) {
                  toast(errorMessage);
                }
                if (state is OfflineLoading) {
                  toast("Data is Syncing...");
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orangeAccent, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.orangeAccent),
                    ),
                  ),
                  onPressed: () {
                    // dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Sync Database"),
                          content: const Text(
                              "Are you sure you want to sync the database?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                offlineCubit.syncData();
                                Navigator.of(context).pop();
                              },
                              child: const Text("Sync"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: state is OfflineLoading
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                  color: Colors.white),
                              10.width,
                              const Text('  SYNCING...'),
                            ],
                          ),
                        )
                      : const Text('SYNC DATABASE'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

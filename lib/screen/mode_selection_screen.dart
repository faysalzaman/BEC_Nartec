import 'package:bec_app/screen/home/offline_home_screen.dart';
import 'package:bec_app/screen/login/login_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:flutter/material.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

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
                  onPressed: () {
                    AppNavigator.goToPage(
                      context: context,
                      screen: const LoginScreen(),
                    );
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orangeAccent, // text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.orangeAccent),
                ),
              ),
              onPressed: () {
                // Handle Sync to Database Logic
              },
              child: const Text('SYNC DATABASE'),
            ),
          ],
        ),
      ),
    );
  }
}

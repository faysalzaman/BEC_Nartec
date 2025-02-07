import 'dart:io';

import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/cubit/wps/wps_cubit.dart';
import 'package:bec_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';

void main() {
  // Add this to ensure proper initialization
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      checkForUpdate();
    }
  }

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Use flexible update instead of immediate for testing
        await InAppUpdate.startFlexibleUpdate();
        // Complete the update when ready
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (e) {
      // Handle exception
      debugPrint('In App Update error: $e');
      // You might want to show a message to the user in production
      // that update checking is only available in production builds
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WpsCubit()),
      ],
      child: MaterialApp(
        title: 'BEC',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            secondary: AppColors.primary,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

import 'dart:io';

import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/cubit/wps/wps_cubit.dart';
import 'package:bec_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        home: UpgradeAlert(
          // check android or ios
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          child: const SplashScreen(),
        ),
      ),
    );
  }
}

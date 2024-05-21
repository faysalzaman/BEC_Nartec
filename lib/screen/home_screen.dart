import 'package:bec_app/global/constant/app_colors.dart';
import 'package:bec_app/screen/data_view/users_screen.dart';
import 'package:bec_app/screen/meal_transaction/scan_employee_meal_screen.dart';
import 'package:bec_app/screen/time_and_attendance/scan_employee_attendance_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/logos/bec_logo.jpeg'),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      AppNavigator.goToPage(
                        context: context,
                        screen: const UsersScreen(),
                      );
                    } else if (index == 1) {
                      AppNavigator.goToPage(
                        context: context,
                        screen: const ScanEmployeeMealScreen(),
                      );
                    } else {
                      AppNavigator.goToPage(
                        context: context,
                        screen: const ScanEmployeeAttendanceScreen(),
                      );
                    }
                  },
                  child: Container(
                    height: context.height() * 0.13,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/card_background.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      color: Colors.blueGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          index == 0
                              ? 'Data View'
                              : index == 1
                                  ? 'Meal Transaction'
                                  : 'Time Attendance',
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

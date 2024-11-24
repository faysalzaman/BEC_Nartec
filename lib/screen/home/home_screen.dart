import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/screen/data_view/users_screen.dart';
import 'package:bec_app/screen/meal_transaction/scan_employee_meal_screen.dart';
import 'package:bec_app/screen/time_and_attendance/check_in_out_selection_screen.dart';
import 'package:bec_app/screen/time_attendance_history/scan_employee_attendance_history.dart';
import 'package:bec_app/screen/transaction_history/scan_transaction_history_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logos/bec_logo.jpeg'),
              SlideTransition(
                position: _slideAnimation,
                child: ListView.builder(
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
                            screen: const CheckInOutSelectionScreen(),
                          );
                        }
                      },
                      child: Container(
                        height: context.height() * 0.12,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image:
                                AssetImage('assets/images/card_background.jpg'),
                            fit: BoxFit.cover,
                          ),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                          color: Colors.blueGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
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
                                fontSize: 20,
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
              ),
              20.height,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: const ScanEmployeeAttendanceHistoryScreen(),
                  );
                },
                child: const Text('View Attendance History'),
              ),
              10.height,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: const ScanTransactionHistoryScreen(),
                  );
                },
                child: const Text('View Transaction History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

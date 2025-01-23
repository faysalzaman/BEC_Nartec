// ignore_for_file: avoid_print

import 'package:bec_app/cubit/employee/employee_cubit.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/screen/transaction_history/user_profile_transaction_history_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class ScanTransactionHistoryScreen extends StatefulWidget {
  const ScanTransactionHistoryScreen({super.key});

  @override
  State<ScanTransactionHistoryScreen> createState() =>
      _ScanTransactionHistoryScreenState();
}

class _ScanTransactionHistoryScreenState
    extends State<ScanTransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController qrTextController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  FocusNode qrTextFocus = FocusNode();
  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();

  EmployeeCubit employeeCubit = EmployeeCubit();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    qrTextController.dispose();
    startDateController.dispose();
    endDateController.dispose();

    qrTextFocus.dispose();
    startDateFocus.dispose();
    endDateFocus.dispose();
    super.dispose();
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
      body: BlocConsumer<EmployeeCubit, EmployeeState>(
        bloc: employeeCubit,
        listener: (context, state) {
          print(state);
          if (state is EmployeeByIdSuccess) {
            print("Image: ${state.employee.getProfilePictureUrl()}");
            AppNavigator.goToPage(
              context: context,
              screen: UserProfileTransactionHistoryScreen(
                employee: state.employee,
                startDate: startDateController.text.trim(),
                endDate: endDateController.text.trim(),
              ),
            );
          }

          if (state is EmployeeError) {
            toast(state.message.replaceAll("Exception:", ""));
          }
        },
        builder: (context, state) {
          return SafeArea(
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
                    child: ScaleTransition(
                      scale: _animation,
                      child: Image.asset(
                        'assets/images/qr_code.png',
                        width: context.width() * 0.2,
                        height: context.height() * 0.1,
                      ),
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
                      onSubmitted: (value) {
                        if (qrTextController.text.isEmpty ||
                            startDateController.text.isEmpty ||
                            endDateController.text.isEmpty) {
                          toast('Please fill in all the fields');
                          return;
                        }
                        qrTextFocus.unfocus();
                        employeeCubit
                            .getEmployeeById(qrTextController.text.trim());
                      },
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
                  10.height,
                  // start date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: startDateController,
                      focusNode: startDateFocus,
                      onSubmitted: (value) {
                        startDateFocus.unfocus();
                        FocusScope.of(context).requestFocus(endDateFocus);
                      },
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  startDateController.text = formattedDate;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_today)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        hintText: 'Start Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  10.height,
                  // end date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: endDateController,
                      focusNode: endDateFocus,
                      onSubmitted: (value) {
                        endDateFocus.unfocus();
                        // loginCubit.login(
                        //   usernameController.text.trim(),
                        //   passwordController.text.trim(),
                        // );
                      },
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  endDateController.text = formattedDate;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_today)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        hintText: 'End Date',
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
                      onPressed: () {
                        if (qrTextController.text.isEmpty ||
                            startDateController.text.isEmpty ||
                            endDateController.text.isEmpty) {
                          toast('Please fill in all the fields');
                          return;
                        }
                        qrTextFocus.unfocus();
                        employeeCubit
                            .getEmployeeById(qrTextController.text.trim());
                      },
                      child: state is EmployeeLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : const Text(
                              'Search',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

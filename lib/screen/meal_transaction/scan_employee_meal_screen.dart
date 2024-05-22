import 'package:bec_app/cubit/employee/employee_cubit.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/screen/meal_transaction/user_profile_meal_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class ScanEmployeeMealScreen extends StatefulWidget {
  const ScanEmployeeMealScreen({super.key});

  @override
  State<ScanEmployeeMealScreen> createState() => _ScanEmployeeMealScreenState();
}

class _ScanEmployeeMealScreenState extends State<ScanEmployeeMealScreen> {
  TextEditingController qrTextController = TextEditingController();
  FocusNode qrTextFocus = FocusNode();

  EmployeeCubit employeeCubit = EmployeeCubit();

  @override
  void dispose() {
    qrTextController.dispose();
    qrTextFocus.dispose();
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
          if (state is EmployeeByIdSuccess) {
            AppNavigator.goToPage(
              context: context,
              screen: UserProfileMealScreen(employees: state.employee),
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
                      onSubmitted: (value) {
                        if (qrTextController.text.isEmpty) {
                          qrTextFocus.unfocus();
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
                        if (qrTextController.text.isEmpty) {
                          qrTextFocus.unfocus();
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

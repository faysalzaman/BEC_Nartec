import 'package:bec_app/constant/app_urls.dart';
import 'package:bec_app/cubit/employee/employee_cubit.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/cubit/transaction/transaction_cubit.dart';
import 'package:bec_app/cubit/transaction/transaction_state.dart';
import 'package:bec_app/model/attendance/ImeiModel2.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class ScanEmployeeMealScreen extends StatefulWidget {
  const ScanEmployeeMealScreen({super.key});

  @override
  State<ScanEmployeeMealScreen> createState() => _ScanEmployeeMealScreenState();
}

class _ScanEmployeeMealScreenState extends State<ScanEmployeeMealScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController qrTextController = TextEditingController();
  FocusNode qrTextFocus = FocusNode();

  EmployeeCubit employeeCubit = EmployeeCubit();
  TransactionCubit transactionCubit = TransactionCubit();

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
    qrTextFocus.dispose();
    super.dispose();
  }

  ImeiModel2 data = ImeiModel2();

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
            transactionCubit.transaction(state.employee.id.toString());
            qrTextController.clear();
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
                  BlocConsumer<TransactionCubit, TransactionState>(
                    bloc: transactionCubit,
                    listener: (context, state) {
                      if (state is TransactionSuccess) {
                        setState(() {
                          data = state.data;
                        });
                        toast(data.message?.replaceAll("Exception:", ""));
                      } else if (state is TransactionError) {
                        toast(state.error.replaceAll("Exception:", ""),
                            bgColor: Colors.red);
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    },
                  ),
                  10.height,
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Visibility(
                      visible: data.transaction?.employee?.employeeCode
                              ?.toString()
                              .isNotEmpty ??
                          false,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${AppUrls.baseUrl}${data.transaction?.employee?.profilePicture?.toString().replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  16.width,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.transaction?.employee?.name ??
                                              "N/A",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        4.height,
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "ID: ${data.transaction?.employee?.employeeCode ?? "N/A"}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    icon: Icons.business,
                                    label: 'Company',
                                    value: data.transaction?.employee
                                            ?.companyName ??
                                        "N/A",
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.work,
                                    label: 'Job Title',
                                    value:
                                        data.transaction?.employee?.jobTitle ??
                                            "N/A",
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.room,
                                    label: 'Room Number',
                                    value: data.transaction?.employee
                                            ?.roomNumber ??
                                        "N/A",
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.category,
                                    label: 'Category',
                                    value:
                                        data.transaction?.employee?.jobTitle ??
                                            "N/A",
                                  ),
                                  12.height,
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.info_outline,
                                            color: AppColors.primary, size: 18),
                                        8.width,
                                        Expanded(
                                          child: Text(
                                            data.message ?? "",
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          8.width,
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

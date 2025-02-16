// ignore_for_file: use_build_context_synchronously

import 'package:bec_app/constant/app_urls.dart';
import 'package:bec_app/cubit/attendance/attendance_cubit.dart';
import 'package:bec_app/cubit/attendance/attendance_state.dart';
import 'package:bec_app/cubit/employee/employee_cubit.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/model/attendance/ImeiModel.dart';
import 'package:bec_app/screen/data_view/user_details.screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class ScanEmployeeAttendanceScreen extends StatefulWidget {
  final bool checkIn;

  final String? wps;
  final String? costCode;

  const ScanEmployeeAttendanceScreen({
    super.key,
    required this.checkIn,
    this.wps,
    this.costCode,
  });

  @override
  State<ScanEmployeeAttendanceScreen> createState() =>
      _ScanEmployeeAttendanceScreenState();
}

class _ScanEmployeeAttendanceScreenState
    extends State<ScanEmployeeAttendanceScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController qrTextController = TextEditingController();
  FocusNode qrTextFocus = FocusNode();

  EmployeeCubit employeeCubit = EmployeeCubit();
  AttendanceCubit attendanceCubit = AttendanceCubit();

  ImeiModel data = ImeiModel();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLoading = false;

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
    _controller.dispose();
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<EmployeeCubit, EmployeeState>(
            bloc: employeeCubit,
            listener: (context, state) {
              if (state is EmployeeByIdSuccess) {
                setState(() {
                  isLoading = true;
                });
                FocusScope.of(context).requestFocus(qrTextFocus);
                if (widget.checkIn) {
                  attendanceCubit.attendanceIn(
                    state.employee.id.toString(),
                    "checkin",
                    widget.wps,
                    widget.costCode,
                    state.employee.adminId ?? 0,
                  );
                } else {
                  attendanceCubit.attendanceIn(
                    state.employee.id.toString(),
                    "checkout",
                    null,
                    null,
                    0,
                  );
                }
                qrTextController.clear();
              }

              if (state is EmployeeError) {
                setState(() {
                  isLoading = false;
                });
                FocusScope.of(context).requestFocus(qrTextFocus);
                toast(state.message.toString().replaceAll("Exception:", ""));
              }
            },
          ),
          BlocListener<AttendanceCubit, AttendanceState>(
            bloc: attendanceCubit,
            listener: (context, state) {
              if (state is AttendanceInError) {
                setState(() {
                  isLoading = false;
                });
                _showErrorDialog(
                    context,
                    state.error
                        .toString()
                        .replaceAll("Exception:", "")
                        .replaceAll("Exception", ""));
              }
              if (state is AttendanceInSuccess) {
                setState(() {
                  isLoading = false;
                  data = state.imei;
                });
                _showSuccessDialog(context,
                    state.imei.message?.replaceAll("Exception:", "") ?? "");
              }
            },
          ),
        ],
        child: SafeArea(
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.checkIn
                        ? "You are Checking In"
                        : "You are Checking Out",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                  child: BlocBuilder<EmployeeCubit, EmployeeState>(
                    bloc: employeeCubit,
                    builder: (context, empState) {
                      return BlocBuilder<AttendanceCubit, AttendanceState>(
                        bloc: attendanceCubit,
                        builder: (context, attState) {
                          return ElevatedButton(
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
                              employeeCubit.getEmployeeById(
                                  qrTextController.text.trim());
                            },
                            child: isLoading ||
                                    empState is EmployeeLoading ||
                                    attState is AttendanceInLoading
                                ? const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Search',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      );
                    },
                  ),
                ),
                20.height,
                if (data.attendance?.employee?.profilePicture != null)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: CachedNetworkImageProvider(
                              "${AppUrls.baseUrl}${data.attendance?.employee?.profilePicture?.toString().replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                            ),
                            width: context.width() * 0.3,
                            height: context.height() * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Employee Code: ${data.attendance?.employee?.employeeCode ?? ""}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () {
                                  _showEmployeeDetailsDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
    );
  }

  void _showEmployeeDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text("Employee Details"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                KeyValueInfoWidget(
                  keyy: 'Name',
                  value: data.attendance?.employee?.name ?? "null",
                ),
                KeyValueInfoWidget(
                  keyy: 'Company',
                  value: data.attendance?.employee?.companyName ?? "null",
                ),
                KeyValueInfoWidget(
                  keyy: 'Job Title',
                  value: data.attendance?.employee?.jobTitle ?? "null",
                ),
                KeyValueInfoWidget(
                  keyy: 'Room Number',
                  value: data.attendance?.employee?.roomNumber ?? "null",
                ),
                KeyValueInfoWidget(
                  keyy: 'Category',
                  value: data.attendance?.employee?.jobTitle ?? "null",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "${data.message}",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: CachedNetworkImageProvider(
                    "${AppUrls.baseUrl}${data.attendance?.employee?.profilePicture?.toString().replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                  ),
                  onBackgroundImageError: (error, stackTrace) {
                    // Handle image loading error
                  },
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Error",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.checkIn
                      ? "Check In Successfully"
                      : "Check Out Successfully",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

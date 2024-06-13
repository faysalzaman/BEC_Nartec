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
  const ScanEmployeeAttendanceScreen({super.key});

  @override
  State<ScanEmployeeAttendanceScreen> createState() =>
      _ScanEmployeeAttendanceScreenState();
}

class _ScanEmployeeAttendanceScreenState
    extends State<ScanEmployeeAttendanceScreen> {
  TextEditingController qrTextController = TextEditingController();
  FocusNode qrTextFocus = FocusNode();

  EmployeeCubit employeeCubit = EmployeeCubit();
  AttendanceCubit attendanceCubit = AttendanceCubit();

  ImeiModel data = ImeiModel();

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
            attendanceCubit.attendanceIn(state.employee.id.toString());
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
                  BlocConsumer<AttendanceCubit, AttendanceState>(
                    bloc: attendanceCubit,
                    listener: (context, state) {
                      if (state is AttendanceInError) {
                        toast(state.error.replaceAll("Exception:", ""));
                      }
                      if (state is AttendanceInSuccess) {
                        setState(() {
                          data = state.imei;
                        });
                        toast(state.imei.message?.replaceAll("Exception:", ""));
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
                  20.height,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                      visible: data.attendance?.employee?.employeeCode
                              ?.toString()
                              .isNotEmpty ??
                          false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.height,
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2, // Set the border width
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${AppUrls.baseUrl}${data.attendance?.employee?.profilePicture?.toString().replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.image_outlined),
                                ),
                              ),
                              10.width,
                              Text(
                                  "Emp Code: ${data.attendance?.employee?.employeeCode?.toString() ?? "null"}"),
                            ],
                          ),
                          10.height,
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10, bottom: 10),
                            child: Text(
                              "${data.message}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          KeyValueInfoWidget(
                            keyy: 'Name',
                            value: data.attendance?.employee?.name ?? "null",
                          ),
                          KeyValueInfoWidget(
                            keyy: 'Company',
                            value: data.attendance?.employee?.companyName ??
                                "null",
                          ),
                          KeyValueInfoWidget(
                            keyy: 'Job Title',
                            value:
                                data.attendance?.employee?.jobTitle ?? "null",
                          ),
                          KeyValueInfoWidget(
                            keyy: 'Room Number',
                            value:
                                data.attendance?.employee?.roomNumber ?? "null",
                          ),
                          KeyValueInfoWidget(
                            keyy: 'Category',
                            value:
                                data.attendance?.employee?.jobTitle ?? "null",
                          ),
                          10.height,
                        ],
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

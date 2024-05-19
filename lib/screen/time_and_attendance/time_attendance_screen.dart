import 'package:bec_app/cubit/attendance/attendance_cubit.dart';
import 'package:bec_app/cubit/attendance/attendance_state.dart';
import 'package:bec_app/global/constant/app_colors.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:bec_app/widgets/attendance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class TimeAndAttendanceScreen extends StatefulWidget {
  const TimeAndAttendanceScreen({super.key, required this.employee});

  final EmployeeModel employee;

  @override
  State<TimeAndAttendanceScreen> createState() =>
      _TimeAndAttendanceScreenState();
}

class _TimeAndAttendanceScreenState extends State<TimeAndAttendanceScreen> {
  int _groupValue = -1;

  AttendanceCubit attendanceCubit = AttendanceCubit();
  AttendanceCubit attendanceInCubit = AttendanceCubit();
  AttendanceCubit attendanceOutCubit = AttendanceCubit();

  @override
  void initState() {
    super.initState();
    attendanceCubit.getAttendance(widget.employee.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Time and Attendance",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SizedBox(
          width: context.width() * 1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      20.height,
                      const Text(
                        "Select IN/OUT for your attendance",
                      ),
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          BlocConsumer<AttendanceCubit, AttendanceState>(
                            bloc: attendanceInCubit,
                            listener: (context, state) {
                              if (state is AttendanceInSuccess) {
                                toast("Check In Successful");
                              }

                              if (state is AttendanceInError) {
                                toast(state.error.replaceAll("Exception:", ""));
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Radio(
                                    fillColor: MaterialStateProperty.all(
                                        AppColors.primary),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 0,
                                    groupValue: _groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _groupValue = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: context.width() * 0.35,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _groupValue == 0
                                            ? AppColors.primary
                                            : Colors.grey[300],
                                        foregroundColor: _groupValue == 0
                                            ? Colors.white
                                            : Colors.grey[600],
                                      ),
                                      onPressed: _groupValue != 0
                                          ? null
                                          : () {
                                              attendanceInCubit.attendanceIn(
                                                  widget.employee.id
                                                      .toString());

                                              attendanceCubit.getAttendance(
                                                  widget.employee.id
                                                      .toString());
                                            },
                                      child: state is AttendanceInLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Check In',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          BlocConsumer<AttendanceCubit, AttendanceState>(
                            bloc: attendanceOutCubit,
                            listener: (context, state) {
                              if (state is AttendanceOutSuccess) {
                                toast("Check Out Successful");
                              }

                              if (state is AttendanceOutError) {
                                toast(state.error.replaceAll("Exception:", ""));
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Radio(
                                    fillColor: MaterialStateProperty.all(
                                        AppColors.primary),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 1,
                                    groupValue: _groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _groupValue = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: context.width() * 0.35,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _groupValue == 1
                                            ? AppColors.primary
                                            : Colors.grey[300],
                                        foregroundColor: _groupValue == 1
                                            ? Colors.white
                                            : Colors.grey[600],
                                      ),
                                      onPressed: _groupValue != 1
                                          ? null
                                          : () {
                                              attendanceOutCubit.attendanceOut(
                                                  widget.employee.id
                                                      .toString());

                                              attendanceCubit.getAttendance(
                                                  widget.employee.id
                                                      .toString());
                                            },
                                      child: state is AttendanceOutLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Check Out',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      20.height,
                    ],
                  ),
                ),
                20.height,
                Column(
                  children: [
                    const Text(
                      'Attendance History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    20.height,
                    BlocConsumer<AttendanceCubit, AttendanceState>(
                      bloc: attendanceCubit,
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is AttendanceLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        if (state is AttendanceError) {
                          return Center(
                            child: Text(
                              state.error.replaceAll("Exception:", ""),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                        if (state is AttendanceSuccess) {
                          return AttendanceCard(attendance: state.attendance);
                        } else {
                          return const Center(
                            child: Text(
                              "No Attendance Record",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

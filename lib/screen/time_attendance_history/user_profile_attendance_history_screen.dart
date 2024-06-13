import 'package:bec_app/cubit/attendance/attendance_cubit.dart';
import 'package:bec_app/cubit/attendance/attendance_state.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:bec_app/widgets/attendance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileAttendanceHistoryScreen extends StatefulWidget {
  const UserProfileAttendanceHistoryScreen({super.key, required this.employee});

  final EmployeeModel employee;

  @override
  State<UserProfileAttendanceHistoryScreen> createState() =>
      _UserProfileAttendanceHistoryScreenState();
}

class _UserProfileAttendanceHistoryScreenState
    extends State<UserProfileAttendanceHistoryScreen> {
  AttendanceCubit attendanceCubit = AttendanceCubit();

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
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Card(
                              margin: const EdgeInsets.all(10.0),
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          width: 150.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          width: 150.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is AttendanceError) {
                          return const Center(
                            child: Text(
                              "No Attendance Record",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
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
                                fontSize: 15,
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

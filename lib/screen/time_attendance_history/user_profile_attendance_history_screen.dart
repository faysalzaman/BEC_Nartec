import 'package:bec_app/cubit/attendance/attendance_cubit.dart';
import 'package:bec_app/cubit/attendance/attendance_state.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:bec_app/model/attendance/AttendanceModel.dart';
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
      backgroundColor: Colors.grey[100],
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Employee Info Card
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              widget.employee.name?[0].toUpperCase() ?? '',
                              style: const TextStyle(
                                fontSize: 24,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.employee.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.employee.jobTitle ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "ID: ${widget.employee.employeeCode}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              20.height,

              // Attendance Records
              BlocConsumer<AttendanceCubit, AttendanceState>(
                bloc: attendanceCubit,
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return _buildShimmerLoading();
                  }
                  if (state is AttendanceError) {
                    return _buildErrorWidget();
                  }
                  if (state is AttendanceSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attendance History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        12.height,
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.attendance.length,
                          itemBuilder: (context, index) {
                            final attendance = state.attendance[index];
                            final duration = _calculateDuration(
                              attendance.checkIn ?? '',
                              attendance.checkOut,
                            );

                            return InkWell(
                              onTap: () => _showAttendanceDetails(attendance),
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      // Date Header
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          8.width,
                                          Text(
                                            _formatDateOnly(
                                                attendance.checkIn ?? ''),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              duration,
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      _buildInfoRow(
                                        'Check In',
                                        '${_formatTimeOnly(attendance.checkIn ?? '')} - IMEI: ${attendance.checkInIMEI ?? 'N/A'}',
                                        Icons.login,
                                        Colors.green,
                                      ),
                                      8.height,
                                      _buildInfoRow(
                                        'Check Out',
                                        attendance.checkOut != null
                                            ? '${_formatTimeOnly(attendance.checkOut!)} - IMEI: ${attendance.checkOutIMEI ?? 'N/A'}'
                                            : 'Not checked out',
                                        Icons.logout,
                                        Colors.red,
                                      ),
                                      8.height,
                                      _buildInfoRow(
                                        'Cost Code',
                                        attendance.costCode ?? 'N/A',
                                        Icons.code,
                                        Colors.orange,
                                      ),
                                      8.height,
                                      _buildInfoRow(
                                        'WBS',
                                        attendance.wps ?? 'N/A',
                                        Icons.work,
                                        Colors.purple,
                                      ),
                                      8.height,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return _buildErrorWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          8.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                2.height,
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Card(
        elevation: 4,
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red[700]),
              12.width,
              Text(
                "No Attendance Record",
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerRow(),
              SizedBox(height: 16),
              ShimmerRow(),
              SizedBox(height: 16),
              ShimmerRow(),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateOnly(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatTimeOnly(String dateTime) {
    final date = DateTime.parse(dateTime);
    final hour =
        date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period";
  }

  String _calculateDuration(String checkIn, String? checkOut) {
    if (checkOut == null) {
      return 'Ongoing';
    }

    final checkInTime = DateTime.parse(checkIn);
    final checkOutTime = DateTime.parse(checkOut);
    final difference = checkOutTime.difference(checkInTime);

    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void _showAttendanceDetails(AttendanceModel attendance) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attendance Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Divider(height: 16),
              _buildDetailRow(
                  'Date', _formatDateOnly(attendance.checkIn ?? '')),
              _buildDetailRow(
                  'Check In Time', _formatTimeOnly(attendance.checkIn ?? '')),
              _buildDetailRow(
                  'Check Out Time',
                  attendance.checkOut != null
                      ? _formatTimeOnly(attendance.checkOut!)
                      : 'Not checked out'),
              _buildDetailRow(
                  'Duration',
                  _calculateDuration(
                      attendance.checkIn ?? '', attendance.checkOut)),
              _buildDetailRow('Check In IMEI', attendance.checkInIMEI ?? 'N/A'),
              _buildDetailRow(
                  'Check Out IMEI', attendance.checkOutIMEI ?? 'N/A'),
              _buildDetailRow('Cost Code', attendance.costCode ?? 'N/A'),
              _buildDetailRow('WPS', attendance.wps ?? 'N/A'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerRow extends StatelessWidget {
  const ShimmerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 12,
              color: Colors.white,
            ),
            8.height,
            Container(
              width: 120,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

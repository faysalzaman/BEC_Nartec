import 'package:bec_app/model/attendance/AttendanceModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceCard extends StatelessWidget {
  final List<AttendanceModel> attendance;

  const AttendanceCard({
    super.key,
    required this.attendance,
  });

  String formatDateTime(String dateTime) {
    // Convert dateTime to Human readable format
    return DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: attendance.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10.0),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Employee ID: ${attendance[index].employeeId.toString()}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Check In:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      attendance[index].checkIn == null
                          ? "Not Checked In Yet"
                          : formatDateTime(
                              attendance[index].checkIn.toString()),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: attendance[index].checkIn == null
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Check Out:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      attendance[index].checkOut == null
                          ? "Not Checked Out Yet"
                          : formatDateTime(
                              attendance[index].checkOut.toString()),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: attendance[index].checkOut == null
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

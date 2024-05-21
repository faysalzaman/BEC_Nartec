// ignore_for_file: unnecessary_null_comparison
import 'package:bec_app/model/attendance/AttendanceModel.dart';
import 'package:bec_app/screen/time_and_attendance/attendance_history.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

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

  DateTime parseDateTime(String dateTime) {
    // Convert dateTime to DateTime object
    return DateTime.parse(dateTime);
  }

  Duration calculateTimeSpent(String checkIn, String checkOut) {
    if (checkIn == null || checkOut == null || checkOut == "0") {
      return Duration.zero;
    }

    DateTime checkInTime = parseDateTime(checkIn);
    DateTime checkOutTime = parseDateTime(checkOut);

    return checkOutTime.difference(checkInTime);
  }

  String getDateString(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Map<String, Duration> calculateTotalTimePerDay(
      List<AttendanceModel> attendance) {
    Map<String, Duration> totalTimePerDay = {};

    for (var record in attendance) {
      String date = getDateString(record.checkIn ?? "0");

      if (!totalTimePerDay.containsKey(date)) {
        totalTimePerDay[date] = Duration.zero;
      }

      totalTimePerDay[date] = (totalTimePerDay[date] ?? Duration.zero) +
          calculateTimeSpent(record.checkIn ?? "0", record.checkOut ?? "0");
    }

    return totalTimePerDay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            AppNavigator.goToPage(
              context: context,
              screen: AttendanceHistory(
                totalTimePerDay: calculateTotalTimePerDay(attendance),
              ),
            );
          },
          child: const Text('View Attendance History'),
        ),
        10.height,
        ListView.separated(
          itemCount: attendance.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card(
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
                            fontSize: 18.0,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time Spent:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        calculateTimeSpent(
                          attendance[index].checkIn ?? "0",
                          attendance[index].checkOut ?? "0",
                        ).toString().substring(0, 7),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

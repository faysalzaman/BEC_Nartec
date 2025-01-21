import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceHistory extends StatelessWidget {
  const AttendanceHistory({
    super.key,
    required this.totalTimePerDay,
  });

  final Map<String, Duration> totalTimePerDay;

  String convertDateFormat(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM, yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Attendance History',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: totalTimePerDay.length,
        itemBuilder: (context, index) {
          String date = totalTimePerDay.keys.elementAt(index);
          Duration time = totalTimePerDay.values.elementAt(index);

          return Card(
            shadowColor: Colors.black,
            color: Colors.white,
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                convertDateFormat(date),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${time.inHours} hours ${time.inMinutes.remainder(60)} minutes ${time.inSeconds.remainder(60)} seconds",
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
          );
        },
      ),
    );
  }
}

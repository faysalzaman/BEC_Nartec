import 'package:bec_app/model/attendance/AttendanceModel.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceInLoading extends AttendanceState {}

class AttendanceInSuccess extends AttendanceState {
  final String message;

  AttendanceInSuccess(this.message);
}

class AttendanceSuccess extends AttendanceState {
  final List<AttendanceModel> attendance;

  AttendanceSuccess(this.attendance);
}

class AttendanceEmpty extends AttendanceState {
  final String message;

  AttendanceEmpty(this.message);
}

class AttendanceError extends AttendanceState {
  final String error;

  AttendanceError(this.error);
}

class AttendanceInError extends AttendanceState {
  final String error;

  AttendanceInError(this.error);
}

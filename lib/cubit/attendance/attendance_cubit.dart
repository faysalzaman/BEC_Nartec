import 'package:bec_app/controller/attendance/attendance_controller.dart';
import 'package:bec_app/cubit/attendance/attendance_state.dart';
import 'package:bec_app/model/attendance/AttendanceModel.dart';
import 'package:bec_app/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  void attendanceIn(String id) async {
    emit(AttendanceInLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(AttendanceInError('No internet connection'));
        return;
      }

      await AttendanceController.attendanceIn(id);
      emit(AttendanceInSuccess());
    } catch (e) {
      emit(AttendanceInError(e.toString()));
    }
  }

  void attendanceOut(String id) async {
    emit(AttendanceOutLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(AttendanceOutError('No internet connection'));
        return;
      }

      await AttendanceController.attendanceOut(id);
      emit(AttendanceOutSuccess());
    } catch (e) {
      emit(AttendanceOutError(e.toString()));
    }
  }

  void getAttendance(String id) async {
    emit(AttendanceLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(AttendanceError('No internet connection'));
        return;
      }

      List<AttendanceModel> response =
          await AttendanceController.getAttendance(id);
      if (response.isEmpty) {
        emit(AttendanceEmpty('No attendance data'));
        return;
      }
      emit(AttendanceSuccess(response));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}

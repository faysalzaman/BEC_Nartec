import 'package:bec_app/controller/attendance/attendance_controller.dart';
import 'package:bec_app/cubit/attendance/attendance_state.dart';
import 'package:bec_app/model/attendance/AttendanceModel.dart';
import 'package:bec_app/model/attendance/ImeiModel.dart';
import 'package:bec_app/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  void attendanceIn(String id, String action, String? wps, String? costCode,
      int? adminId) async {
    emit(AttendanceInLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(AttendanceInError('No internet connection'));
        return;
      }

      ImeiModel data = await AttendanceController.attendanceIn(
        id,
        action,
        wps,
        costCode,
        adminId,
      );
      emit(AttendanceInSuccess(data));
    } catch (e) {
      emit(AttendanceInError(e.toString()));
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

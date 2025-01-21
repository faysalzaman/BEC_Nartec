// ... existing imports ...

// ignore_for_file: avoid_print

import 'package:bec_app/controller/attendance/attendance_controller.dart';
import 'package:bec_app/cubit/wps/wps_state.dart';
import 'package:bec_app/model/attendance/WpsModel.dart';
import 'package:bec_app/model/attendance/locationModel.dart';
import 'package:bec_app/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WpsCubit extends Cubit<WpsState> {
  WpsCubit() : super(WpsInitial());

  void getLocation() async {
    emit(LocationLoading());
    try {
      List<LocationModel> response = await AttendanceController.getLocation();
      emit(LocationSuccess(response));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void getWps(int locationId) async {
    emit(WpsLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(WpsError('No internet connection'));
        return;
      }

      List<WpsModel> response1 = await AttendanceController.getWps(locationId);
      List<WpsModel> response2 = await AttendanceController.getCostCode();

      emit(WpsSuccess(response1)); // Updated state emission
      emit(CostCodeSuccess(response2));
    } catch (e) {
      print(e);
      emit(WpsError(e.toString()));
    }
  }
}

// ... existing code ...

import 'package:bec_app/controller/employee/employee_controller.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/utils/network.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeeInitial());

  void getEmployee() async {
    emit(EmployeeLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(EmployeeError('No internet connection'));
        return;
      }

      List<EmployeeModel> response = await EmployeeController.getEmployee();
      emit(EmployeeSuccess(response));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  void getEmployeeById(String id) async {
    emit(EmployeeLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(EmployeeError('No internet connection'));
        return;
      }

      EmployeeModel response = await EmployeeController.getEmployeeById(id);
      emit(EmployeeByIdSuccess(response));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}

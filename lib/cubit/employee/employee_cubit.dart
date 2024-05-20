import 'package:bec_app/controller/employee/employee_controller.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/utils/network.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeeInitial());

  static EmployeeCubit get(context) => BlocProvider.of<EmployeeCubit>(context);

  int page = 1, limit = 10;

  List<EmployeeModel> employees = [];
  List<EmployeeModel> filteredList = [];
  TextEditingController searchController = TextEditingController();

  void getEmployee({bool more = false}) async {
    if (more == false) {
      emit(EmployeeLoading());
    } else {
      emit(EmployeeLoadMoreLoading());
    }
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(EmployeeError('No internet connection'));
        return;
      }

      List<EmployeeModel> response =
          await EmployeeController.getEmployee(page, limit);

      if (more == true) {
        page++;
        emit(EmployeeLoadMoreSuccess(response));
        return;
      }

      emit(EmployeeSuccess(response));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  // search employee
  void searchEmployee() async {
    emit(EmployeeLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(EmployeeError('No internet connection'));
        return;
      }

      List<EmployeeModel> response =
          await EmployeeController.searchEmployee(searchController.text.trim());

      emit(EmployeeSearchSuccess(response));
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

import 'package:bec_app/model/Employee/EmployeeModel.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoadMoreLoading extends EmployeeState {}

class EmployeeSearchLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final List<EmployeeModel> employees;

  EmployeeSuccess(this.employees);
}

class EmployeeLoadMoreSuccess extends EmployeeState {
  final List<EmployeeModel> employees;

  EmployeeLoadMoreSuccess(this.employees);
}

class EmployeeSearchSuccess extends EmployeeState {
  final List<EmployeeModel> employees;

  EmployeeSearchSuccess(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError(this.message);
}

class EmployeeLoadMoreError extends EmployeeState {
  final String message;

  EmployeeLoadMoreError(this.message);
}

class EmployeeSearchError extends EmployeeState {
  final String message;

  EmployeeSearchError(this.message);
}

class EmployeeByIdSuccess extends EmployeeState {
  final EmployeeModel employee;

  EmployeeByIdSuccess(this.employee);
}

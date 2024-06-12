import 'package:bec_app/model/attendance/ImeiModel2.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final ImeiModel2 data;

  TransactionSuccess(this.data);
}

class TransactionError extends TransactionState {
  final String error;

  TransactionError(this.error);
}

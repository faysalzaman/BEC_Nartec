import 'package:bec_app/model/attendance/ImeiModel2.dart';
import 'package:bec_app/model/transaction/TransactionHistoryModel.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

// Loading
class TransactionLoading extends TransactionState {}

class TransactionHistoryLoading extends TransactionState {}

// Success
class TransactionSuccess extends TransactionState {
  final ImeiModel2 data;

  TransactionSuccess(this.data);
}

class TransactionHistorySuccess extends TransactionState {
  final TransactionHistoryModel data;

  TransactionHistorySuccess(this.data);
}

// Error
class TransactionError extends TransactionState {
  final String error;

  TransactionError(this.error);
}

class TransactionHistoryError extends TransactionState {
  final String error;

  TransactionHistoryError(this.error);
}

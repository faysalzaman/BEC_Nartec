abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final String message;

  TransactionSuccess(this.message);
}

class TransactionError extends TransactionState {
  final String error;

  TransactionError(this.error);
}

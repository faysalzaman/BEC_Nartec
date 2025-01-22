import 'package:bec_app/controller/transaction/transaction_controller.dart';
import 'package:bec_app/cubit/transaction/transaction_state.dart';
import 'package:bec_app/model/attendance/ImeiModel2.dart';
import 'package:bec_app/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  void transaction(String empId) async {
    emit(TransactionLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(TransactionError('No internet connection'));
        return;
      }
      ImeiModel2 data = await TransactionController.transaction(empId);
      emit(TransactionSuccess(data));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  void getTransactionHistory(
    String id, {
    String? startDate,
    String? endDate,
  }) async {
    emit(TransactionHistoryLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(TransactionHistoryError('No internet connection'));
        return;
      }
      var response = await TransactionController.getTransactionHistory(
        id: id,
        startDate: startDate,
        endDate: endDate,
      );

      emit(TransactionHistorySuccess(response));
    } catch (e) {
      emit(TransactionHistoryError(e.toString()));
    }
  }
}

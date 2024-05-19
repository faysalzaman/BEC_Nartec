import 'package:bec_app/controller/transaction/transaction_controller.dart';
import 'package:bec_app/cubit/transaction/transaction_state.dart';
import 'package:bec_app/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  void transaction(String empId, String mealType) async {
    emit(TransactionLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(TransactionError('No internet connection'));
        return;
      }

      await TransactionController.transaction(empId, mealType);
      emit(TransactionSuccess());
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}

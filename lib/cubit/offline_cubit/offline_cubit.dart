import 'package:bec_app/controller/offline/offline_controller.dart';
import 'package:bec_app/cubit/offline_cubit/offline_state.dart';
import 'package:bec_app/utils/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineCubit extends Cubit<OfflineState> {
  OfflineCubit() : super(OfflineInitial());

  void syncData() async {
    emit(OfflineLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(OfflineError('No internet connection'));
        return;
      }

      await OfflineController.transferTransactionToDatabase();
      await OfflineController.transferAttendanceToDatabase();
      emit(OfflineLoaded());
    } catch (e) {
      emit(OfflineError(e.toString()));
    }
  }
}

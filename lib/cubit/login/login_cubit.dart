import 'package:bec_app/controller/login/login_controller.dart';
import 'package:bec_app/cubit/login/login_states.dart';
import 'package:bec_app/constant/app_preferences.dart';
import 'package:bec_app/utils/network.dart';
import 'package:bec_app/model/login/LoginModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login(String email, String password) async {
    emit(LoginLoading());
    try {
      bool networkStatus = await Network.check();
      if (!networkStatus) {
        emit(LoginError('No internet connection'));
        return;
      }

      LoginModel response = await AuthController.login(email, password);

      await AppPreferences.setToken(response.token!);
      await AppPreferences.setUserId(response.adminUser!.userId.toString());
      await AppPreferences.setEmail(response.adminUser!.email.toString());
      await AppPreferences.setName(response.adminUser!.name.toString());

      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}

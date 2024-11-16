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

      AppPreferences.setToken(response.token!).then((value) {});
      AppPreferences.setUserId(response.adminUser!.id.toString())
          .then((value) {});
      AppPreferences.setEmail(response.adminUser!.email.toString())
          .then((value) {});
      AppPreferences.setName(response.adminUser!.name.toString())
          .then((value) {});

      emit(LoginSuccess(response));
    } catch (e) {
      print(e);
      emit(LoginError(e.toString()));
    }
  }
}

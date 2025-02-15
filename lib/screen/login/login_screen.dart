// ignore_for_file: prefer_const_constructors

import 'package:bec_app/constant/app_preferences.dart';
import 'package:bec_app/cubit/login/login_cubit.dart';
import 'package:bec_app/cubit/login/login_states.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/screen/login/pick_location_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  String deviceId = "Unknown";

  @override
  void initState() {
    super.initState();
    getDeviceDetails();
  }

  Future<void> getDeviceDetails() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      if (await Permission.phone.request().isGranted) {
        fetchDeviceId();
      } else {
        setState(() {
          deviceId = "Permission Denied";
        });
      }
    } else {
      fetchDeviceId();
    }
  }

  Future<void> fetchDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      setState(() {
        deviceId = androidInfo.id; // Use androidId as a fallback
      });
      AppPreferences.setImei(deviceId.toString()).then((value) {});
    } catch (e) {
      setState(() {
        deviceId = "Failed to get device info";
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  LoginCubit loginCubit = LoginCubit();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<LoginCubit, LoginState>(
        bloc: loginCubit,
        listener: (context, state) {
          if (state is LoginSuccess) {
            AppNavigator.replaceTo(
              context: context,
              screen: PickLocationScreen(
                locations: state.loginModel.adminUser!.locations ?? [],
              ),
            );
          }

          if (state is LoginError) {
            toast(state.error.replaceAll("Exception:", ""));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logos/bec_logo.jpeg'),
                  const Text(
                    "Welcome to the",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Employee Time Managemenet",
                    style: TextStyle(fontSize: 18),
                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Device ID: ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        " $deviceId",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  30.height,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: usernameController,
                      focusNode: usernameFocus,
                      onSubmitted: (value) {
                        usernameFocus.unfocus();
                        FocusScope.of(context).requestFocus(passwordFocus);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        hintText: 'User ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  20.height,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      onSubmitted: (value) {
                        passwordFocus.unfocus();
                        // loginCubit.login(
                        //   usernameController.text.trim(),
                        //   passwordController.text.trim(),
                        // );
                      },
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  40.height,
                  SizedBox(
                    width: context.width() * 0.6,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        loginCubit.login(
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                      child: state is LoginLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

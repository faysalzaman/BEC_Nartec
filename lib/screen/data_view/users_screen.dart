import 'package:bec_app/cubit/employee/employee_cubit.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/global/constant/app_colors.dart';
import 'package:bec_app/global/constant/app_urls.dart';
import 'package:bec_app/screen/data_view/user_details.screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  EmployeeCubit employeeCubit = EmployeeCubit();

  @override
  void initState() {
    super.initState();
    employeeCubit.getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<EmployeeCubit, EmployeeState>(
        bloc: employeeCubit,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const ShimmerWidgetForEmployeesList();
          }

          if (state is EmployeeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        "https://img.freepik.com/free-vector/error-404-concept-illustration_114360-1811.jpg?size=626&ext=jpg",
                    fit: BoxFit.cover,
                  ),
                  20.height,
                  const Text(
                    "No Employees Found!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  20.height,
                  ElevatedButton(
                    onPressed: () {
                      employeeCubit.getEmployee();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return state is EmployeeSuccess
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //back button
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),

                            Column(
                              children: [
                                const Text(
                                  'Employees',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Total Employees: ${state.employees.length}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        20.height,
                        ListView.builder(
                          itemCount: state.employees.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              width: context.width() * 0.9,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                title: Text(
                                  state.employees[index].name ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Employee Code ${state.employees[index].employeeCode!}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                                leading: Hero(
                                  tag: state.employees[index].id!,
                                  child: ClipOval(
                                    child: Image.network(
                                      state.employees[index].profilePicture ==
                                              null
                                          ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                          : "${AppUrls.baseUrl}${state.employees[index].profilePicture?.replaceAll("\\", "/")}",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    // move to User Details Page
                                    AppNavigator.goToPage(
                                      context: context,
                                      screen: UserDetailsScreen(
                                          employees: state.employees[index]),
                                    );
                                  },
                                  child: Image.asset("assets/images/view.png"),
                                ),
                                onTap: () {
                                  // AppNavigator.goToPage(
                                  //   context: context,
                                  //   screen: const UsersScreen(id: "1"),
                                  // );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}

class ShimmerWidgetForEmployeesList extends StatelessWidget {
  const ShimmerWidgetForEmployeesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: Column(
        children: [
          20.height,
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Employees',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total Employees: 0',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Column(),
            ],
          ),
          ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: context.width() * 0.9,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Container(
                    width: 100,
                    height: 20,
                    color: Colors.grey,
                  ),
                  subtitle: Container(
                    width: 50,
                    height: 20,
                    color: Colors.grey,
                  ),
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                  ),
                  trailing: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:bec_app/cubit/employee/employee_cubit.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/constant/app_urls.dart';
import 'package:bec_app/screen/data_view/search_user_screen.dart';
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
  final EmployeeCubit employeeCubit = EmployeeCubit();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    employeeCubit.getEmployee();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      employeeCubit.getEmployee(more: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int totalEmp = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.primary),
        title: Text(
          "Employees (${totalEmp.toString()})",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AppNavigator.goToPage(
                context: context,
                screen: const SearchUsersScreen(),
              );
            },
            icon: const Icon(Icons.search, size: 26),
          ),
        ],
      ),
      body: BlocConsumer<EmployeeCubit, EmployeeState>(
        bloc: employeeCubit,
        listener: (context, state) {
          if (state is EmployeeSuccess) {
            employeeCubit.employees = state.employees;
            setState(() {
              totalEmp = state.employees.length;
            });
          } else if (state is EmployeeLoadMoreSuccess) {
            employeeCubit.employees.addAll(state.employees);
            setState(() {
              totalEmp = employeeCubit.employees.length;
            });
          }
        },
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
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  24.height,
                  const Text(
                    "No Employees Found!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  16.height,
                  ElevatedButton.icon(
                    onPressed: () => employeeCubit.getEmployee(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  16.height,
                  ListView.builder(
                    itemCount: employeeCubit.employees.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final employee = employeeCubit.employees[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            employee.name ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              8.height,
                              GestureDetector(
                                onTap: () {
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen:
                                        UserDetailsScreen(employees: employee),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "ID: ${employee.employeeCode!}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          leading: Hero(
                            tag: employee.id!,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: employee.profilePicture == null
                                      ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                      : "${AppUrls.baseUrl}/${employee.profilePicture?.replaceAll("\\", "/").replaceAll("//", "/")}",
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              AppNavigator.goToPage(
                                context: context,
                                screen: UserDetailsScreen(employees: employee),
                              );
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/view.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (state is EmployeeLoadMoreLoading) ...[
                    20.height,
                    const CircularProgressIndicator(color: AppColors.primary),
                    20.height,
                  ],
                ],
              ),
            ),
          );
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
          ListView.builder(
            itemCount: 10,
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

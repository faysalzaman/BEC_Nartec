import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:bec_app/cubit/employee/employee_cubit.dart';
import 'package:bec_app/cubit/employee/employee_state.dart';
import 'package:bec_app/global/constant/app_colors.dart';
import 'package:bec_app/global/constant/app_urls.dart';
import 'package:bec_app/screen/data_view/user_details.screen.dart';
import 'package:bec_app/screen/data_view/users_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final EmployeeCubit employeeCubit = EmployeeCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<EmployeeCubit, EmployeeState>(
        bloc: employeeCubit,
        listener: (context, state) {
          if (state is EmployeeSearchSuccess) {
            employeeCubit.filteredList = state.employees;
            return;
          }
        },
        builder: (context, state) {
          if (state is EmployeeSearchLoading) {
            return const ShimmerWidgetForEmployeesList();
          }

          if (state is EmployeeSearchError) {
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

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimationSearchBar(
                    backIcon: Icons.arrow_back,
                    backIconColor: Colors.black,
                    centerTitle:
                        'Total Employees: ${employeeCubit.filteredList.length}',
                    centerTitleStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      employeeCubit.searchEmployee();
                    },
                    searchTextEditingController: employeeCubit.searchController,
                    horizontalPadding: 5,
                  ),
                  employeeCubit.filteredList.isEmpty
                      ? SizedBox(
                          height: context.height() * 0.8,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 200,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Search for Employees",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: employeeCubit.filteredList.length,
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
                                  employeeCubit.filteredList[index].name ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Employee Code ${employeeCubit.filteredList[index].employeeCode!}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                leading: Hero(
                                  tag: employeeCubit.filteredList[index].id!,
                                  child: ClipOval(
                                    child: Image.network(
                                      employeeCubit.filteredList[index]
                                                  .profilePicture ==
                                              null
                                          ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                          // replace all the \\ with / in the profile picture url and put the one / after the base url
                                          : "${AppUrls.baseUrl}/${employeeCubit.filteredList[index].profilePicture?.replaceAll("\\", "/").replaceAll("//", "/")}",
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
                                          employees: employeeCubit
                                              .filteredList[index]),
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
                  20.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

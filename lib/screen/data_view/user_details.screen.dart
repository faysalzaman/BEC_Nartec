// ignore_for_file: non_const_call_to_literal_constructor

import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/constant/app_urls.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.employees});

  final EmployeeModel employees;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.employees.employeeCode);
    print(widget.employees.username);
    print(widget.employees.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                width: context.width() * 1,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                    ),
                  ],
                  // curve only from bottom sides
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2, // Set the border width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 8,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: widget.employees.id.toString(),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.employees.profilePicture == null
                                ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                : "${AppUrls.baseUrl}/${widget.employees.profilePicture?.replaceAll("\\", "/").replaceAll("//", "/")}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    20.height,
                    SizedBox(
                      width: context.width() * 0.8,
                      child: Text(
                        widget.employees.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    10.height,
                  ],
                ),
              ),
              10.height,
              SizedBox(
                width: 100,
                height: 100,
                child: PrettyQrView.data(
                  data: widget.employees.employeeCode ?? "null",
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
              KeyValueInfoWidget(
                keyy: 'Name',
                value: widget.employees.name ?? "null",
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
              KeyValueInfoWidget(
                keyy: 'User Name',
                value: widget.employees.username ?? "",
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
              KeyValueInfoWidget(
                keyy: 'Employee Code',
                value: widget.employees.employeeCode ?? "null",
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
              KeyValueInfoWidget(
                keyy: 'Location',
                value: widget.employees.location?.name ?? "null",
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
              KeyValueInfoWidget(
                keyy: 'Nationality',
                value: widget.employees.nationality ?? "null",
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
              KeyValueInfoWidget(
                keyy: 'Company Name',
                value: widget.employees.companyName ?? "",
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeyValueInfoWidget extends StatelessWidget {
  const KeyValueInfoWidget({
    super.key,
    required this.keyy,
    required this.value,
  });

  final String keyy;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 6,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 3,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              keyy,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(':'),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

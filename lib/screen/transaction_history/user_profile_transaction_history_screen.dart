import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/cubit/transaction/transaction_cubit.dart';
import 'package:bec_app/cubit/transaction/transaction_state.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:bec_app/widgets/transaction_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileTransactionHistoryScreen extends StatefulWidget {
  const UserProfileTransactionHistoryScreen({
    super.key,
    required this.employee,
    required this.startDate,
    required this.endDate,
  });

  final EmployeeModel employee;
  final String startDate;
  final String endDate;

  @override
  State<UserProfileTransactionHistoryScreen> createState() =>
      _UserProfileTransactionHistoryScreenState();
}

class _UserProfileTransactionHistoryScreenState
    extends State<UserProfileTransactionHistoryScreen> {
  TransactionCubit transactionCubit = TransactionCubit();

  @override
  void initState() {
    super.initState();
    transactionCubit.getTransactionHistory(
      widget.employee.id.toString(),
      startDate: widget.startDate,
      endDate: widget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Transaction History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SizedBox(
          width: context.width() * 1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    BlocConsumer<TransactionCubit, TransactionState>(
                      bloc: transactionCubit,
                      listener: (context, state) {
                        if (state is TransactionHistoryError) {
                          toast(state.error.replaceAll("Exception:", ""));
                        }
                        if (state is TransactionHistorySuccess) {
                          toast("Transaction History Loaded");
                        }
                      },
                      builder: (context, state) {
                        if (state is TransactionHistoryLoading) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Card(
                              margin: const EdgeInsets.all(10.0),
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          width: 150.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          width: 150.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is TransactionHistoryError) {
                          return const Center(
                            child: Text(
                              "No Attendance Record",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }
                        if (state is TransactionHistorySuccess) {
                          return TransactionCard(
                              transaction: state.data.transaction!);
                        } else {
                          return const Center(
                            child: Text(
                              "No Transaction Record",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

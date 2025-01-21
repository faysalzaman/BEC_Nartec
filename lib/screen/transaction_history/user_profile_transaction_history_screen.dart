import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/cubit/transaction/transaction_cubit.dart';
import 'package:bec_app/cubit/transaction/transaction_state.dart';
import 'package:bec_app/model/Employee/EmployeeModel.dart';
import 'package:bec_app/widgets/transaction_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
        elevation: 2,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        radius: 25,
                        child: Text(
                          widget.employee.name![0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.employee.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "ID: ${widget.employee.id}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.startDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: Colors.grey[400]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "To",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.endDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocConsumer<TransactionCubit, TransactionState>(
                  bloc: transactionCubit,
                  listener: (context, state) {
                    if (state is TransactionHistoryError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No Transaction Record"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is TransactionHistoryLoading) {
                      return _buildShimmerLoading();
                    }
                    if (state is TransactionHistoryError) {
                      return _buildErrorState();
                    }
                    if (state is TransactionHistorySuccess) {
                      return TransactionCard(
                        transaction: state.data.transaction!,
                      );
                    }
                    return _buildEmptyState();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 120, height: 20),
                    ShimmerBox(width: 80, height: 20),
                  ],
                ),
                SizedBox(height: 12),
                ShimmerBox(width: double.infinity, height: 16),
                SizedBox(height: 8),
                ShimmerBox(width: 150, height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            "No Transaction Record",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "No Transaction Record",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

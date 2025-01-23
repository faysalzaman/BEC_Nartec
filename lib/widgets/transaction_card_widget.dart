import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/model/transaction/TransactionHistoryModel.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final List<Transaction> transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transaction.length,
      itemBuilder: (context, index) {
        var trans = transaction[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Colors.grey[300],
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRow(
                      context, 'Employee Name:', trans.employee!.name ?? ''),
                  buildRow(
                      context, 'Job Title:', trans.employee!.jobTitle ?? ''),
                  buildRow(context, 'Employee ID:', trans.employeeId ?? ''),
                  buildRow(context, 'Device ID:', trans.iMEI ?? ''),
                  buildRow(context, 'Date:', trans.date ?? ''),
                  buildRow(context, 'Meal Type:', trans.mealType ?? ''),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildRow(BuildContext context, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

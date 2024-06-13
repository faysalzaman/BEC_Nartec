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
            shadowColor: Colors.grey[300],
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRow(context, 'Employee Name:', trans.employee!.name),
                  buildRow(context, 'Job Title:', trans.employee!.jobTitle),
                  buildRow(context, 'Employee ID:', trans.employeeId),
                  const SizedBox(height: 10),
                  buildRow(context, 'Device ID:', trans.iMEI),
                  buildRow(context, 'Date:', trans.date),
                  buildRow(context, 'Meal Type:', trans.mealType),
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
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

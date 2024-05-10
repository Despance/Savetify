import 'package:flutter/material.dart';
import 'package:savetify/models/expense.dart';
import 'package:savetify/widgets/expenses_lists/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (BuildContext context, int index) =>
          ExpenseItem(expense: expenses[index]),
    );
  }
}

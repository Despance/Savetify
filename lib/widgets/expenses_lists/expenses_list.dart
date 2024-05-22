import 'package:flutter/material.dart';
import 'package:savetify/models/expense.dart';
import 'package:savetify/widgets/expenses_lists/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (BuildContext context, int index) => Dismissible(
          key: ValueKey(expenses[index]),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseItem(expense: expenses[index])),
    );
  }
}

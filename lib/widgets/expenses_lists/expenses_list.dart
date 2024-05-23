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
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            child: Icon(Icons.delete_outline_outlined,
                color: Colors.white, size: 40),
            alignment: Alignment.centerRight,
            margin: Theme.of(context).cardTheme.margin,
            padding: const EdgeInsets.only(right: 20),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseItem(expense: expenses[index])),
    );
  }
}

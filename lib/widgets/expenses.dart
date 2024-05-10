import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/widgets/expenses_lists/expenses_list.dart';
import 'package:savetify/models/expense.dart';
import 'package:savetify/widgets/nex_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Groceries',
        amount: 100.0,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Uber',
        amount: 50.0,
        date: DateTime.now(),
        category: Category.transportation),
    Expense(
        title: 'Rent',
        amount: 1000.0,
        date: DateTime.now(),
        category: Category.housing),
    Expense(
        title: 'Netflix',
        amount: 10.0,
        date: DateTime.now(),
        category: Category.subscriptions),
    Expense(
        title: 'Concert',
        amount: 100.0,
        date: DateTime.now(),
        category: Category.entertainment),
    Expense(
        title: 'Other',
        amount: 50.0,
        date: DateTime.now(),
        category: Category.other),
    Expense(
        title: 'dinner',
        amount: 50.99,
        date: DateTime.now(),
        category: Category.other),
    Expense(
        title: 'lunch',
        amount: 20.0,
        date: DateTime.now(),
        category: Category.other),
    Expense(
        title: 'breakfast',
        amount: 10.0,
        date: DateTime.now(),
        category: Category.other),
    Expense(
        title: 'snack',
        amount: 5.0,
        date: DateTime.now(),
        category: Category.other),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return const NewExpense();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Expenses'),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.add),
              onPressed: _openAddExpenseOverlay,
            )
          ],
        ),
        body: Column(children: [
          const Text('The chart'),
          Expanded(child: ExpensesList(expenses: _registeredExpenses)),
        ]));
  }
}

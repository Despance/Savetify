import 'package:flutter/material.dart';
import 'package:savetify/models/expense.dart';

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
        category: Category.Food),
    Expense(
        title: 'Uber',
        amount: 50.0,
        date: DateTime.now(),
        category: Category.Transportation),
    Expense(
        title: 'Rent',
        amount: 1000.0,
        date: DateTime.now(),
        category: Category.Housing),
    Expense(
        title: 'Netflix',
        amount: 10.0,
        date: DateTime.now(),
        category: Category.Subscriptions),
    Expense(
        title: 'Concert',
        amount: 100.0,
        date: DateTime.now(),
        category: Category.Entertainment),
    Expense(
        title: 'Other',
        amount: 50.0,
        date: DateTime.now(),
        category: Category.Other),
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(children: [Text('The chart'), Text('Expenses List')]));
  }
}

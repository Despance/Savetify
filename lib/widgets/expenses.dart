import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/widgets/chart/chart.dart';
import 'package:savetify/widgets/expenses_lists/expenses_list.dart';
import 'package:savetify/models/expense.dart';
import 'package:savetify/widgets/new_expense.dart';

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
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return NewExpense(onAddExpense: _addExpense);
        });
  }

  void _addExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Expense "${expense.title}" deleted!'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            })));
  }

  @override
  Widget build(BuildContext context) {
    Widget maincontent = const Center(
      child: Text('No expenses added yet... Please add some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      maincontent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 33, 251, 113),
          title: const Text('Expenses'),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.add),
              onPressed: _openAddExpenseOverlay,
            )
          ],
        ),
        body: Column(children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: maincontent)
        ]));
  }
}

class ExpenseBucket {
  ExpenseBucket(this.expenses, this.category);
  ExpenseBucket.forCategory(List<Expense> expenses, this.category)
      : expenses =
            expenses.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expenses;
  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }
}

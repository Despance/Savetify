import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: const Center(
        child: Text(
          'Expense Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

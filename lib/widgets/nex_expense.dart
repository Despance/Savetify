import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(label: Text('Title')),
            maxLength: 50,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Date'),
            keyboardType: TextInputType.datetime,
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}

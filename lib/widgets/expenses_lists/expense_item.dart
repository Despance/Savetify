import 'package:flutter/material.dart';
import 'package:savetify/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});
  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromARGB(255, 234, 0, 255),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 12, 221, 224), // Starting color
                Color.fromARGB(255, 39, 179, 37), // Ending color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.7], // Gradient stops
            ),
            borderRadius: BorderRadius.circular(10), // Border radius if needed
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('\$${expense.amount.toStringAsFixed(2)} '),
                    const Spacer(),
                    Row(children: [
                      Icon(categoryIcons[expense.category]),
                      const SizedBox(width: 8),
                      Text(expense.formattedDate)
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

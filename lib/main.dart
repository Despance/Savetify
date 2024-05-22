import 'package:flutter/material.dart';
import 'package:savetify/widgets/expenses.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 235, 167, 247)),
      home: const Expenses()));
}

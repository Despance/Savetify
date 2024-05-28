import 'package:flutter/material.dart';
import 'package:savetify/src/features/home/view/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Expense Tracker",
      home: HomeScreen(),
    );
  }
}

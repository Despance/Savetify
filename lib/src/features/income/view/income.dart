import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
      ),
      body: const Center(
        child: Text(
          'Income Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

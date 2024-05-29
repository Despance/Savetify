import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/home/views/main_screen.dart';
import 'package:savetify/src/features/investment/view/investmentView.dart';
import 'package:savetify/src/features/expense/view/expense.dart';
import 'package:savetify/src/features/income/view/IncomeView.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.chart_pie),
                title: const Text('Investments'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 1; // Index for Investments
                  });
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.arrow_down),
                title: const Text('Expenses'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 2; // Index for Expenses
                  });
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.arrow_up),
                title: Text('Income'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 3; // Index for Income
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final List<Widget> _pages = [
    MainScreen(),
    InvestmentPage(),
    ExpensePage(),
    IncomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_pie),
              label: "Investments",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_down),
              label: "Expenses",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_up),
              label: "Income",
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPopupMenu(context),
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
    );
  }
}

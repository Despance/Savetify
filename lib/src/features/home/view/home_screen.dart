import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/expense/view/add_expense.dart';
import 'package:savetify/src/features/home/view/main_screen.dart';
import 'package:savetify/src/features/income/view/IncomeView.dart';
import 'package:savetify/src/features/investment/view/investment.dart';
import 'package:savetify/src/features/report/view/ReportView.dart';
import 'package:savetify/src/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

  late List<Widget> widgetList;

  int index = 0;
  late Color selectedColor;
  Color unselectedColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    widgetList = [
      MainScreen(key: mainScreenKey),
      const IncomePage(),
      const InvestmentPage(),
      const ReportView(),
    ];
    selectedColor = SavetifyTheme.lightTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            backgroundColor: SavetifyTheme.lightTheme.scaffoldBackgroundColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 3,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                    color: index == 0 ? selectedColor : unselectedColor,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.increase_indent,
                      color: index == 1 ? selectedColor : unselectedColor),
                  label: 'Incomes'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.money_dollar_circle,
                      color: index == 2 ? selectedColor : unselectedColor),
                  label: 'Invesments'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.bookmark,
                      color: index == 3 ? selectedColor : unselectedColor),
                  label: 'Reports'),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddExpense();
                },
              ),
            ).then((value) => mainScreenKey.currentState!.setState(() {}));
          },
          shape: const CircleBorder(),
          child: Container(
            alignment: Alignment.center,
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  SavetifyTheme.lightTheme.primaryColor,
                  const Color.fromARGB(239, 108, 247, 247),
                  const Color.fromARGB(255, 96, 91, 255),
                ],
                transform: const GradientRotation(pi / 5),
              ),
            ),
            child: const Icon(CupertinoIcons.add),
          ),
        ),
        body: switch (index) {
          0 => widgetList[0],
          1 => widgetList[1],
          2 => widgetList[2],
          3 => widgetList[3],
          // TODO: Handle this case.
          int() => throw UnimplementedError(),
        });
  }
}

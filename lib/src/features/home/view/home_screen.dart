import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/expense/view/add_expense.dart';
import 'package:savetify/src/features/home/view/main_screen.dart';
import 'package:savetify/src/features/income/view/IncomeView.dart';
import 'package:savetify/src/features/investment/view/InvestmentView.dart';
import 'package:savetify/src/features/report/view/ReportView.dart';
import 'package:savetify/src/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();
  final GlobalKey<IncomePageState> incomePageKey = GlobalKey<IncomePageState>();
  final GlobalKey<InvestmentPageState> investmentPageKey =
      GlobalKey<InvestmentPageState>();

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

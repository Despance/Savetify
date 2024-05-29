import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/expense/view/add_expense.dart';
import 'package:savetify/src/features/home/view/main_screen.dart';
import 'package:savetify/src/features/income/view/IncomeView.dart';
import 'package:savetify/src/features/report/view_model/stats.dart';
import 'package:savetify/src/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
    widgetList = [MainScreen(key: mainScreenKey), const IncomePage()];
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
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.increase_indent,
                  color: index == 2 ? selectedColor : unselectedColor),
              label: 'Incomes',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return AddExpense();
          //     },
          //   ),
          // ).then((value) => mainScreenKey.currentState!.setState(() {}));
          _showMenu(context);
        },
        shape: CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                SavetifyTheme.lightTheme.primaryColor,
                const Color.fromARGB(239, 108, 247, 247),
                const Color.fromARGB(255, 96, 91, 255),
              ],
              transform: GradientRotation(pi / 5),
            ),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: switch (index) {
        0 => widgetList[0],
        1 => widgetList[1],
        // TODO: Handle this case.
        int() => throw UnimplementedError(),
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    // Add Income
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddExpense()),
                    ).then(
                        (value) => mainScreenKey.currentState!.setState(() {}));
                  },
                  label: Text('Add Income'),
                  heroTag: 'addIncome',
                  icon: Icon(Icons.attach_money),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    // Add Investment
                    // Your navigation logic here
                  },
                  label: Text('Add Investment'),
                  heroTag: 'addInvestment',
                  icon: Icon(Icons.trending_up),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    // Add Expense
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddExpense()),
                    ).then(
                        (value) => mainScreenKey.currentState!.setState(() {}));
                  },
                  label: Text('Add Expense'),
                  heroTag: 'addExpense',
                  icon: Icon(Icons.payment),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

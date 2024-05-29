import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/expense/view/add_expense.dart';
import 'package:savetify/src/features/home/view/main_screen.dart';
import 'package:savetify/src/features/income/view/IncomeView.dart';
import 'package:savetify/src/features/investment/view/InvestmentView.dart';
import 'package:savetify/src/features/report/view_model/stats.dart';
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
      IncomePage(key: incomePageKey),
      InvestmentPage(key: investmentPageKey),
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
        2 => widgetList[2],
        int() => throw UnimplementedError(),
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: 20.0), // Alt tarafa boşluk eklemek için padding
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        // Add Income
                        _showAddIncomeDialog(context);
                      },
                      label: Text('Add Income'),
                      heroTag: 'addIncome',
                      icon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        // Add Investment
                        investmentPageKey.currentState!
                            .showInvestmentForm(context);
                      },
                      label: const Text('Add Investment'),
                      heroTag: 'addInvestment',
                      icon: const Icon(Icons.trending_up),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        // Add Expense
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddExpense()),
                        ).then((value) =>
                            mainScreenKey.currentState!.setState(() {}));
                      },
                      label: Text('Add Expense'),
                      heroTag: 'addExpense',
                      icon: Icon(Icons.payment),
                    ),
                  ),
                ),
                SizedBox(height: 25), // Alt tarafa boşluk eklemek için SizedBox
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddIncomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String description = '';
        String amount = '';
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          title: Text('Add Income'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(hintText: "Description"),
              ),
              TextField(
                onChanged: (value) {
                  amount = value;
                },
                decoration: InputDecoration(hintText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2028),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    selectedDate = pickedDate;
                  }
                },
                child: Text('Select Date'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                incomePageKey.currentState?.addIncomeScreen();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

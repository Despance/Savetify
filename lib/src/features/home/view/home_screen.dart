import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/expense/view/add_expense.dart';
import 'package:savetify/src/features/home/view/main_screen.dart';
import 'package:savetify/src/features/report/view_model/stats.dart';
import 'package:savetify/src/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var widgetList = [
    MainScreen(),
    StatScreen(),
  ];
  int index = 0;
  late Color selectedColor;
  Color unselectedColor = Colors.grey;

  @override
  void initState() {
    selectedColor = SavetifyTheme.lightTheme.primaryColor;
    super.initState();
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
                icon: Icon(CupertinoIcons.bitcoin_circle,
                    color: index == 1 ? selectedColor : unselectedColor),
                label: 'Investments'),
            /*     BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.graph_circle), label: 'Stats'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_crop_circle),
                  label: 'Profile')*/
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddExpense();
          }));
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
      body: index == 0 ? widgetList[0] : widgetList[1],
    );
  }
}

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savetify/src/features/expense/model/expense_repository.dart';
import 'package:savetify/src/features/expense/view/add_expense.dart';
import 'package:savetify/src/features/income/model/IncomeRepository.dart';
import 'package:savetify/src/features/income/view_model/IncomeViewModel.dart';
import 'package:savetify/src/features/profile/model/user.dart';
import 'package:savetify/src/features/profile/view/profile_view.dart';
import 'package:savetify/src/theme/theme.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  UserModel? userModel;
  late IncomeViewModel incomeViewModel;
  ExpenseRepository? expenseRepository;
  late String result;

  initPage() async {
    incomeViewModel = IncomeViewModel(incomeRepository: IncomeRepository());
    userModel = await const ProfileView().getUser();
    expenseRepository = ExpenseRepository();
    await expenseRepository!.getExpensesFromFirebase();
    await incomeViewModel.getIncomesFromFirebase();
    incomeViewModel.getIncomes();
    result =
        "₺ ${(incomeViewModel.getTotalIncome() - calculateTotalExpense()).toStringAsFixed(2)}";
  }

  double calculateTotalExpense() {
    double total = 0;
    for (var i = 0; i < expenseRepository!.getExpenses().length; i++) {
      total += expenseRepository!.getExpenses()[i].amount;
    }
    return total;
  }

  void Update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
              future: initPage(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            // Larger screen layout
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildHeader(),
                                        const SizedBox(height: 20),
                                        buildBalanceCard(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        buildTransactionsHeader(),
                                        const SizedBox(height: 10),
                                        buildTransactionsList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Small screen layout
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Column(
                                children: [
                                  buildHeader(),
                                  const SizedBox(height: 20),
                                  buildBalanceCard(),
                                  const SizedBox(height: 20),
                                  buildTransactionsHeader(),
                                  const SizedBox(height: 10),
                                  buildTransactionsList(),
                                ],
                              ),
                            );
                          }
                        },
                      );
              }),
          floatingActionButton: FloatingActionButton(
            backgroundColor: SavetifyTheme.lightTheme.primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddExpense();
                  },
                ),
              ).then((value) => Update());
            },
            child: const Icon(Icons.add),
          )),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ProfileView();
                    }));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightBlue[100],
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.person_fill,
                        color: Colors.black,
                        size: 35,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome,',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: SavetifyTheme.lightTheme.secondaryHeaderColor)),
                Text(
                  userModel == null ? 'User' : userModel!.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SavetifyTheme.lightTheme.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBalanceCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height / 3, // Adjust this as needed
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 193, 145, 0),
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 96, 91, 255),
            const Color.fromARGB(239, 108, 247, 247),
            SavetifyTheme.lightTheme.primaryColor,
          ],
          transform: const GradientRotation(pi / 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          const Text("Total Balance",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          const SizedBox(height: 12),
          Text(result,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: result.contains('-')
                    ? const Color.fromARGB(255, 157, 15, 5)
                    : const Color.fromARGB(255, 6, 127, 10),
              )),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildIncomeExpenseInfo(
                  CupertinoIcons.arrow_up,
                  const Color.fromARGB(255, 2, 141, 35),
                  "Income",
                  "₺ ${incomeViewModel.getTotalIncome()}",
                ),
                buildIncomeExpenseInfo(
                  CupertinoIcons.arrow_down,
                  const Color.fromARGB(255, 189, 1, 1),
                  "Expense",
                  "₺ ${calculateTotalExpense()}",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildIncomeExpenseInfo(
      IconData icon, Color iconColor, String title, String amount) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            color: Colors.white30,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 15),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
            Text(amount,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ],
        )
      ],
    );
  }

  Widget buildTransactionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Recent Transactions",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: SavetifyTheme.lightTheme.secondaryHeaderColor)),
        ),
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: Text("Refresh List",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: SavetifyTheme.lightTheme.secondaryHeaderColor)),
        ),
      ],
    );
  }

  Widget buildTransactionsList() {
    return expenseRepository!.getExpenses().isEmpty
        ? const Center(child: Text('No expenses found'))
        : Expanded(
            child: ListView.builder(
                itemCount: expenseRepository!.getExpenses().length,
                itemBuilder: (context, int i) {
                  return ExpenseCard(i);
                }),
          );
  }

  Widget ExpenseCard(int i) {
    return Dismissible(
      key: Key(expenseRepository!.getExpenses()[i].id!),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final deletedExpense = expenseRepository!.getExpenses()[i];
        expenseRepository!.deleteExpenseFromFirebase(deletedExpense.id!);
        setState(() {
          expenseRepository!.getExpenses().removeAt(i);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense "${deletedExpense.description}" deleted'),
            backgroundColor: const Color.fromARGB(255, 118, 9, 1),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  expenseRepository!.getExpenses().insert(i, deletedExpense);
                  expenseRepository!.sendToFirebase(deletedExpense);
                });
              },
            ),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: const Color.fromARGB(255, 177, 20, 9).withOpacity(0.5),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddExpense(
                  expenseModel: expenseRepository!.getExpenses()[i],
                );
              },
            ),
          );
        },
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(207, 252, 226, 1)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(77, 255, 255, 255),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    'lib/src/assets/${expenseRepository!.getExpenses()[i].category}.png'),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expenseRepository!.getExpenses()[i].description,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            expenseRepository!.getExpenses()[i].category,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₺ ${expenseRepository!.getExpenses()[i].amount.toString()}",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy")
                            .format(expenseRepository!.getExpenses()[i].date)
                            .toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

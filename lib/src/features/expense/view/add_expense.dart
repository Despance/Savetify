import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/expense/model/ExpenseRepository.dart';
import 'package:savetify/src/features/expense/view_model/ExpenseViewModel.dart';
import 'package:savetify/src/theme/theme.dart';

class AddExpense extends StatefulWidget {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  ExpenseModel? expenseModel;

  AddExpense({super.key, this.expenseModel});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ExpenseViewModel expenseViewModel = ExpenseViewModel(ExpenseRepository());
  DateTime selectedDate = DateTime.now();
  List<String> myCategoryIcons = [
    'entertainment',
    'food',
    'shopping',
    'other',
    'home',
    'travel',
  ];

  @override
  void initState() {
    super.initState();
    dateController.text =
        DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
    if (widget.expenseModel != null) {
      expenseController.text = widget.expenseModel!.amount.toString();
      categoryController.text = widget.expenseModel!.category;
      dateController.text =
          DateFormat("dd/MM/yyyy").format(widget.expenseModel!.date).toString();
      descriptionController.text = widget.expenseModel!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: SavetifyTheme.lightTheme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: SavetifyTheme.lightTheme.secondaryHeaderColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Add Expense",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: expenseController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'[0-9,.]')), // Sadece rakam, virgül ve nokta girilmesine izin verir
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Amount",
                      prefixIcon: Icon(
                        CupertinoIcons.money_dollar,
                        color: Colors.grey[600],
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Enter the amount",
                    ),
                    onChanged: (value) {
                      if (value.contains(',')) {
                        value = value.replaceAll(',', '.');
                        expenseController.value = TextEditingValue(
                          text: value,
                          selection:
                              TextSelection.collapsed(offset: value.length),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "description",
                        prefixIcon: Icon(
                          CupertinoIcons.app_badge_fill,
                          color: Colors.grey[600],
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter the description",
                      )),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemCount: myCategoryIcons.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      categoryController.text =
                                          myCategoryIcons[index];
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: categoryController.text ==
                                                  myCategoryIcons[index]
                                              ? Colors.green
                                              : Colors.grey[300]!,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'lib/src/assets/${myCategoryIcons[index]}.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Category",
                        prefixIcon: Icon(
                          CupertinoIcons.square_stack,
                          color: Colors.grey[600],
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter the category",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (newDate != null) {
                      dateController.text =
                          DateFormat("dd/MM/yyyy").format(newDate).toString();
                      selectedDate = newDate;
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Date",
                    prefixIcon: Icon(
                      CupertinoIcons.calendar_today,
                      color: Colors.grey[600],
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter the date",
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: kToolbarHeight,
                  child: TextButton(
                    onPressed: () {
                      widget.expenseModel != null
                          ? ExpenseRepository().sendToFirebaseUpdate(
                              ExpenseModel(
                                id: widget.expenseModel!.id,
                                description: descriptionController.text,
                                amount: double.parse(expenseController.text),
                                date: selectedDate,
                                category: categoryController.text,
                              ),
                            )
                          : ExpenseRepository().sendToFirebase(
                              ExpenseModel(
                                description: descriptionController.text,
                                amount: double.parse(expenseController.text),
                                date: selectedDate,
                                category: categoryController.text,
                              ),
                            );
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: SavetifyTheme.lightTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

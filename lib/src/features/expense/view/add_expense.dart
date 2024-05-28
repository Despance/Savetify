import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:savetify/src/theme/theme.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
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
    dateController.text =
        DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
    super.initState();
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
        body: Padding(
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
                    hintText: "Enter the title of the expense",
                  ),
                ),
              ),
              const SizedBox(height: 48),
              TextFormField(
                readOnly: true,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        bool isExpended = false;
                        String iconSelected = ' ';
                        Color categoryColor = Colors.white;
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: const Text("Create Category"),
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: () {
                                      setState(() {
                                        isExpended = !isExpended;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: const Icon(
                                          CupertinoIcons.chevron_down),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Icon",
                                      border: OutlineInputBorder(
                                        borderRadius: isExpended
                                            ? const BorderRadius.vertical(
                                                top: Radius.circular(15),
                                              )
                                            : const BorderRadius.all(
                                                Radius.circular(15)),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  isExpended
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(15),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        mainAxisSpacing: 5,
                                                        crossAxisSpacing: 5),
                                                itemCount:
                                                    myCategoryIcons.length,
                                                itemBuilder: (context, int i) {
                                                  return GestureDetector(
                                                    onTap: () => setState(() {
                                                      iconSelected =
                                                          myCategoryIcons[i];
                                                    }),
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: iconSelected ==
                                                                    myCategoryIcons[
                                                                        i]
                                                                ? Colors.green
                                                                : Colors.grey[
                                                                    300]!),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    15)),
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'lib/src/assets/${myCategoryIcons[i]}.png'),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx2) {
                                            return AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ColorPicker(
                                                    pickerColor: Colors.red,
                                                    onColorChanged: (value) {
                                                      setState(() {
                                                        categoryColor = value;
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                    width: double.infinity,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(ctx2);
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            SavetifyTheme
                                                                .lightTheme
                                                                .primaryColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
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
                                            );
                                          });
                                    },
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      isDense: true,
                                      fillColor: categoryColor,
                                      hintText: "Color",
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      });
                },
                controller: categoryController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Category",
                  prefixIcon: Icon(
                    CupertinoIcons.square_stack,
                    color: Colors.grey[600],
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.add, color: Colors.grey[600]),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter the title of the expense",
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
                  hintText: "Enter the title of the expense",
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: kToolbarHeight,
                child: TextButton(
                  onPressed: () {},
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
    );
  }
}

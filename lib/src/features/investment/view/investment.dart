import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({Key? key}) : super(key: key);

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  late SharedPreferences _prefs;
  final List<Map<String, String>> investments = [];
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String unitAmount = '';
  String totalValue = '';
  String unitPrice = '';
  String date = '';
  String selectedType = 'Unit Amount';

  @override
  void initState() {
    super.initState();
    _loadInvestments();
  }

  Future<void> _loadInvestments() async {
  _prefs = await SharedPreferences.getInstance();
  final List<String>? investmentList = _prefs.getStringList('investments');
  if (investmentList != null) {
    setState(() {
      investments.clear();
      investments.addAll(investmentList.map((json) => _decodeJson(json)));
    });
  }
}

Map<String, String> _decodeJson(String json) {
  final Map<String, dynamic> decodedJson = jsonDecode(json);
  return decodedJson.map((key, value) => MapEntry(key, value.toString()));
}

  Future<void> _saveInvestments() async {
    final List<String> investmentStrings =
        investments.map((investment) => jsonEncode(investment)).toList();
    await _prefs.setStringList('investments', investmentStrings);
  }

  void _showInvestmentForm(BuildContext context,
      {Map<String, String>? investment, int? index}) {
    if (investment != null) {
      name = investment['name']!;
      unitAmount = investment['unitAmount']!;
      totalValue = investment['totalValue']!;
      unitPrice = investment['unitPrice']!;
      date = investment['date']!;
      selectedType = unitAmount.isNotEmpty ? 'Unit Amount' : 'Total Value';
    } else {
      name = '';
      unitAmount = '';
      totalValue = '';
      unitPrice = '';
      date = '';
      selectedType = 'Unit Amount';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(investment != null ? 'Edit Investment' : 'New Investment'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: name,
                        decoration:
                            const InputDecoration(labelText: 'Investment Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment name';
                          }
                          return null;
                        },
                        onSaved: (value) => name = value!,
                      ),
                      TextFormField(
                        controller: TextEditingController(text: unitPrice),
                        decoration: const InputDecoration(
                            labelText: 'Investment Unit Price (\$)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment unit price';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          unitPrice = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        items:
                            ['Unit Amount', 'Total Value'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType = newValue!;
                            if (selectedType == 'Unit Amount') {
                              totalValue = '';
                            } else {
                              unitAmount = '';
                            }
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Select Input Type'),
                      ),
                      const SizedBox(height: 10),
                      selectedType == 'Unit Amount'
                          ? TextFormField(
                              controller:
                                  TextEditingController(text: unitAmount),
                              decoration: const InputDecoration(
                                  labelText: 'Unit Amount'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the unit amount';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                unitAmount = value;
                              },
                            )
                          : TextFormField(
                              controller:
                                  TextEditingController(text: totalValue),
                              decoration: const InputDecoration(
                                  labelText: 'Total Value (\$)'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the total value';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                totalValue = value;
                              },
                            ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Date'),
                        readOnly: true,
                        controller: TextEditingController(text: date),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              date =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                        onSaved: (value) => date = value!,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    double calculatedValue;
                    if (selectedType == 'Unit Amount') {
                      calculatedValue =
                          double.parse(unitAmount) * double.parse(unitPrice);
                      totalValue = calculatedValue.toStringAsFixed(2);
                    } else {
                      calculatedValue = double.parse(totalValue);
                    }

                    if (index != null) {
                      investments[index] = {
                        'name': name,
                        'unitAmount': unitAmount,
                        'totalValue': totalValue,
                        'unitPrice': unitPrice,
                        'date': date,
                      };
                    } else {
                      investments.add({
                        'name': name,
                        'unitAmount': unitAmount,
                        'totalValue': totalValue,
                        'unitPrice': unitPrice,
                        'date': date,
                      });
                    }
                    _saveInvestments();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteInvestment(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Investment'),
          content:
              const Text('Are you sure you want to delete this investment?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  investments.removeAt(index);
                  _saveInvestments();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () => _showInvestmentForm(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInvestments,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ],
                transform: const GradientRotation(pi / 4),
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.grey.shade300,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Total Investments",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${totalInvestmentValue.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: investments.length,
              itemBuilder: (context, index) {
                final investment = investments[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(investment['name']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unit Amount: ${investment['unitAmount']}'),
                        Text('Unit Price: ${investment['unitPrice']}'),
                        Text('Date: ${investment['date']}'),
                        Text('Total Value: ${investment['totalValue']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.pencil),
                          onPressed: () => _showInvestmentForm(context,
                              investment: investment, index: index),
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.trash),
                          onPressed: () => _deleteInvestment(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double get totalInvestmentValue {
    double total = 0.0;
    for (var investment in investments) {
      total += double.parse(investment['totalValue']!);
    }
    return total;
  }
}

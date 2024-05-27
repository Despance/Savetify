import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class InvestmentPage extends StatefulWidget {
  const InvestmentPage({Key? key}) : super(key: key);

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  final List<Map<String, String>> investments = [];
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String unitAmount = '';
  String totalValue = '';
  String unitPrice = '';
  String date = '';
  String selectedType = 'Unit Amount';
  bool hideValues = false; // State for hiding investment values

  final TextEditingController _unitAmountController = TextEditingController();
  final TextEditingController _totalValueController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();

  double get totalInvestmentValue {
    double total = 0.0;
    for (var investment in investments) {
      total += double.parse(investment['value']!);
    }
    return total;
  }

  @override
  void dispose() {
    _unitAmountController.dispose();
    _totalValueController.dispose();
    _unitPriceController.dispose();
    super.dispose();
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

    _unitAmountController.text = unitAmount;
    _totalValueController.text = totalValue;
    _unitPriceController.text = unitPrice;

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
                        controller: _unitPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Investment Unit Price (\$)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment unit price';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _unitPriceController.value =
                              _unitPriceController.value.copyWith(
                            text: value.replaceAll(',', '.'),
                          );
                        },
                        onSaved: (value) => unitPrice = value!,
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
                              _totalValueController.clear();
                            } else {
                              unitAmount = '';
                              _unitAmountController.clear();
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select Input Type',
                        ),
                      ),
                      const SizedBox(height: 10),
                      selectedType == 'Unit Amount'
                          ? TextFormField(
                              controller: _unitAmountController,
                              decoration: const InputDecoration(
                                labelText: 'Unit Amount',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the unit amount';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _unitAmountController.value =
                                    _unitAmountController.value.copyWith(
                                  text: value.replaceAll(',', '.'),
                                );
                              },
                              onSaved: (value) => unitAmount = value!,
                            )
                          : TextFormField(
                              controller: _totalValueController,
                              decoration: const InputDecoration(
                                labelText: 'Total Value (\$)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the total value';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _totalValueController.value =
                                    _totalValueController.value.copyWith(
                                  text: value.replaceAll(',', '.'),
                                );
                              },
                              onSaved: (value) => totalValue = value!,
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
                            lastDate: DateTime(2101),
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
                      unitAmount = (calculatedValue / double.parse(unitPrice))
                          .toStringAsFixed(2); // Unit amount calculation
                    }

                    if (index != null) {
                      investments[index] = {
                        'name': name,
                        'unitAmount': unitAmount,
                        'totalValue': totalValue,
                        'unitPrice': unitPrice,
                        'date': date,
                        'value': calculatedValue.toStringAsFixed(2),
                      };
                    } else {
                      investments.add({
                        'name': name,
                        'unitAmount': unitAmount,
                        'totalValue': totalValue,
                        'unitPrice': unitPrice,
                        'date': date,
                        'value': calculatedValue.toStringAsFixed(2),
                      });
                    }
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Investments'),
            IconButton(
              icon: Icon(hideValues ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  hideValues = !hideValues;
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
              ], transform: const GradientRotation(pi / 4)),
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
                  hideValues
                      ? '***'
                      : "\$ ${totalInvestmentValue.toStringAsFixed(2)}",
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
                        Text(
                            hideValues ? 'Unit Amount: ***' : 'Unit Amount: \$${investment['unitAmount']}'),
                        Text('Unit Price: \$${investment['unitPrice']}'),
                        Text('Date: ${investment['date']}'),
                        Text(
                            hideValues ? 'Total Value: ***' : 'Total Value: \$${investment['value']}'),
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
}


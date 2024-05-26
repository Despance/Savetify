import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  final List<Map<String, String>> investments = [];
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String amount = '';
  String unitPrice = '';
  String date = '';
  String currency = '';

  void _showInvestmentForm(BuildContext context, {Map<String, String>? investment, int? index}) {
    if (investment != null) {
      name = investment['name']!;
      amount = investment['amount']!;
      unitPrice = investment['unitPrice']!;
      currency = investment['currency']!;
      date = investment['date']!;
    } else {
      name = '';
      amount = '';
      unitPrice = '';
      currency = '';
      date = '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(investment != null ? 'Edit Investment' : 'New Investment'),
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
                        decoration: const InputDecoration(labelText: 'Investment Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment name';
                          }
                          return null;
                        },
                        onSaved: (value) => name = value!,
                      ),
                      TextFormField(
                        initialValue: amount,
                        decoration: const InputDecoration(labelText: 'Investment Amount'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment amount';
                          }
                          return null;
                        },
                        onSaved: (value) => amount = value!,
                      ),
                      TextFormField(
                        initialValue: unitPrice,
                        decoration: const InputDecoration(labelText: 'Investment Unit Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment unit price';
                          }
                          return null;
                        },
                        onSaved: (value) => unitPrice = value!,
                      ),
                      DropdownButtonFormField<String>(
                        value: currency.isEmpty ? null : currency,
                        decoration: const InputDecoration(labelText: 'Currency'),
                        items: ['USD', 'EUR', 'TRY'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            currency = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a currency';
                          }
                          return null;
                        },
                        onSaved: (value) => currency = value!,
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
                              date = DateFormat('yyyy-MM-dd').format(pickedDate);
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
                    if (index != null) {
                      investments[index] = {
                        'name': name,
                        'amount': amount,
                        'unitPrice': unitPrice,
                        'currency': currency,
                        'date': date,
                      };
                    } else {
                      investments.add({
                        'name': name,
                        'amount': amount,
                        'unitPrice': unitPrice,
                        'currency': currency,
                        'date': date,
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
          content: const Text('Are you sure you want to delete this investment?'),
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
        title: const Text('Investments'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () => _showInvestmentForm(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: investments.length,
        itemBuilder: (context, index) {
          final investment = investments[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(investment['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: ${investment['amount']} ${investment['currency']}'),
                  Text('Unit Price: ${investment['unitPrice']} ${investment['currency']}'),
                  Text('Date: ${investment['date']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.pencil),
                    onPressed: () => _showInvestmentForm(context, investment: investment, index: index),
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
    );
  }
}

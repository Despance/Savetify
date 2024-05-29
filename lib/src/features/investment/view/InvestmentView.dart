import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';
import 'package:savetify/src/features/investment/model/InvestmentRepository.dart';
import 'package:savetify/src/features/investment/view_model/InvestmentViewModel.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  InvestmentPageState createState() => InvestmentPageState();
}

class InvestmentPageState extends State<InvestmentPage> {
  final _formKey = GlobalKey<FormState>();

  late InvestmentViewModel viewModel;

  late TextEditingController _nameController;
  late TextEditingController _unitAmountController;
  late TextEditingController _totalValueController;
  late TextEditingController _unitPriceController;
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedType = 'Unit Amount';

  bool _isInvestmentValueVisible = true;

  void _toggleInvestmentValueVisibility() {
    setState(() {
      _isInvestmentValueVisible = !_isInvestmentValueVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _unitAmountController = TextEditingController();
    _totalValueController = TextEditingController();
    _unitPriceController = TextEditingController();
    viewModel = InvestmentViewModel(InvestmentModelRepository());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitAmountController.dispose();
    _totalValueController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  showInvestmentForm(BuildContext context,
      {InvestmentModel? investment, int? index}) {
    if (investment != null) {
      _nameController.text = investment.name;
      _unitAmountController.text = investment.unitAmount;
      _totalValueController.text = investment.value;
      _unitPriceController.text = investment.unitPrice;
      _date = investment.date;
      selectedType =
          _unitAmountController.text.isNotEmpty ? 'Unit Amount' : 'Total Value';
      selectedType =
          _unitAmountController.text.isNotEmpty ? 'Unit Amount' : 'Total Value';
    } else {
      _nameController.clear();
      _unitAmountController.clear();
      _totalValueController.clear();
      _unitPriceController.clear();
      _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      selectedType = 'Unit Amount';
    }

    return showDialog(
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
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Investment Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _unitPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Investment Unit Price (\₺)',
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
                              _totalValueController.clear();
                            } else {
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
                                labelText: 'Investment Unit Amount',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an investment unit amount';
                                }
                                return null;
                              },
                            )
                          : TextFormField(
                              controller: _totalValueController,
                              decoration: const InputDecoration(
                                labelText: 'Total Value (₺)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the total value';
                                }
                                return null;
                              },
                            ),
                      TextFormField(
                        initialValue: _date,
                        decoration:
                            const InputDecoration(labelText: 'Investment Date'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _date =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an investment date';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final newInvestment = InvestmentModel(
                    name: _nameController.text,
                    unitAmount: _unitAmountController.text,
                    unitPrice: _unitPriceController.text,
                    date: _date,
                    value: selectedType == 'Unit Amount'
                        ? (double.parse(_unitAmountController.text) *
                                double.parse(_unitPriceController.text))
                            .toStringAsFixed(2)
                        : _totalValueController.text,
                  );
                  if (investment != null && index != null) {
                    await viewModel.updateInvestmentModel(
                        investment.id!, newInvestment);
                  } else {
                    await viewModel.addInvestmentModel(newInvestment);
                  }
                  setState(() {}); // To update the UI after saving
                  Navigator.of(context).pop();
                }
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
        centerTitle: true,
        title: const Text('Investments'),
      ),
      body: FutureBuilder(
        future: viewModel.loadInvestmentModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return FutureBuilder<double>(
              future: viewModel.getTotalInvestmentModelsValue(),
              builder: (context, totalSnapshot) {
                if (totalSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (totalSnapshot.hasError) {
                  return Center(child: Text('Error: ${totalSnapshot.error}'));
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
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
                              Row(
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
                                  IconButton(
                                    icon: Icon(
                                      _isInvestmentValueVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: _toggleInvestmentValueVisibility,
                                  ),
                                ],
                              ),
                              // const SizedBox(width: 10),

                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isInvestmentValueVisible
                                        ? "₺ ${totalSnapshot.data!.toStringAsFixed(2)}"
                                        : '****',
                                    style: const TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // IconButton(
                                  //   icon: Icon(
                                  //     _isInvestmentValueVisible
                                  //         ? Icons.visibility
                                  //         : Icons.visibility_off,
                                  //     color: Colors.white,
                                  //   ),
                                  //   onPressed: _toggleInvestmentValueVisibility,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.investmentModels.length,
                          itemBuilder: (context, index) {
                            final investment =
                                viewModel.investmentModels[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(investment.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Unit Amount: ${investment.unitAmount}'),
                                    Text(_isInvestmentValueVisible
                                        ? 'Unit Amount: ${investment.unitAmount}'
                                        : 'Unit Amount: ****'),
                                    Text('Unit Price: ${investment.unitPrice}'),
                                    Text('Date: ${investment.date}'),
                                    Text(_isInvestmentValueVisible
                                        ? 'Total Value: ${investment.value} ₺'
                                        : 'Total Value: ****'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(CupertinoIcons.pencil),
                                      onPressed: () => showInvestmentForm(
                                          context,
                                          investment: investment,
                                          index: index),
                                    ),
                                    IconButton(
                                      icon: const Icon(CupertinoIcons.trash),
                                      onPressed: () async {
                                        await viewModel
                                            .deleteInvestmentModel(index);
                                        setState(
                                            () {}); // To update the UI after deletion
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInvestmentForm(context);
        },
        child: const Icon(CupertinoIcons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

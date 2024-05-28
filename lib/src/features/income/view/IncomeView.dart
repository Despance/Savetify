import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savetify/src/features/income/model/IncomeModel.dart';
import 'package:savetify/src/features/income/view_model/IncomeViewModel.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final IncomeViewModel incomeViewModel = IncomeViewModel();

  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late DateTime _selectedStartingDate;

  @override
  void initState() {
    super.initState();

    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _selectedStartingDate = DateTime.now();

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initData(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : Center(
                    child: ListView(scrollDirection: Axis.vertical, children: [
                      ...getIncomes(),
                    ]),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addIncome(),
        heroTag: 'addIncome',
        tooltip: 'Add Income',
        child: const Icon(Icons.add),
      ),
    );
  }

  _addIncome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => addIncomeScreen(),
      ),
    );
  }

  List<Widget> getIncomes() {
    if (incomeViewModel.getIncomes().isEmpty) {
      return [
        const Text("No investments found"),
      ];
    } else {
      return [
        for (var investment in incomeViewModel.getIncomes())
          Card(
            elevation: 4,
            child: ListTile(
              title: Text(investment.description),
              subtitle: Text(investment.amount.toString()),
              trailing: Text(investment.date.toString()),
            ),
          ),
      ];
    }
  }

  Widget addIncomeScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Report'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description',
            ),
          ),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(
                  r'[0-9,.]')), // Sadece rakam, virgül ve nokta girilmesine izin verir
            ],
            decoration: const InputDecoration(
              hintText: 'Enter amount',
            ),
          ),
          TextButton(
            onPressed: () async => _selectedStartingDate = await _selectDate(),
            child: const Text("Select Start Date"),
          ),
          TextButton(
            onPressed: () => {
              //TODO: Add the income to the database
              incomeViewModel.setIncomesFromFirebase(
                IncomeModel(
                    description: _descriptionController.text,
                    amount: double.parse(_amountController.text),
                    date: _selectedStartingDate),
              ),
              Navigator.pop(context),
              setState(() => incomeViewModel.getIncomes()), // refresh the view
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  _selectDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
  }

  _initData() async {
    await incomeViewModel.getIncomesFromFirebase();
    incomeViewModel.getIncomes();
  }

/*
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

 */

  /*
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
  
  */
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();

    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _selectedDate = DateTime.now();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initData(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: Center(child: CircularProgressIndicator()))
              : Center(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text("Incomes",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center)),
                      ...getIncomes(),
                    ],
                  ),
                );
        },
      ),
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
    ).then((value) => {
          _descriptionController.clear(),
          _amountController.clear(),
          _selectedDate = DateTime.now(),
        });
  }

  List<Widget> getIncomes() {
    if (incomeViewModel.getIncomes().isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text("No incomes found. Please add some incomes.",
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center),
        ),
      ];
    } else {
      return [
        for (var income in incomeViewModel.getIncomes())
          Dismissible(
            key: Key(income.id!),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              incomeViewModel.deleteIncomeFromFirebase(income);
              setState(() {});
            },
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(income.description),
                subtitle: Text('₺${income.amount}'),
                trailing: Text(_formatDate(income.date)),
              ),
            ),
          ),
      ];
    }
  }

  _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget addIncomeScreen() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter description',
              ),
            ),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(
                    r'[0-9,.]')), // Sadece rakam, virgül ve nokta girilmesine izin verir
              ],
              decoration: const InputDecoration(
                hintText: 'Enter amount',
              ),
            ),
            TextButton(
              onPressed: () async => _selectedDate = await _selectDate(),
              child: const Text("Select Start Date"),
            ),
            TextButton(
              onPressed: () => {
                if (_descriptionController.text.isNotEmpty &&
                    _amountController.text.isNotEmpty)
                  {
                    incomeViewModel.addIncomesToFirebase(
                      IncomeModel(
                          description: _descriptionController.text,
                          amount: double.parse(_amountController.text),
                          date: _selectedDate),
                    ),
                  },
                Navigator.pop(context),
                setState(() => {}), // refresh the view
              },
              child: const Text("Save"),
            ),
          ],
        ),
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
}

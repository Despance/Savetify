import 'package:flutter/material.dart';
import 'package:savetify/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.other;
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatAmount);
  }

  void _formatAmount() {
    final text = _amountController.text;
    final newText = text.replaceAll(",", ".");
    if (text != newText) {
      _amountController.value = _amountController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  void _submitExpense() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);
    if (enteredTitle.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content:
                    const Text('Please enter a valid title, amount and date'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Okay')),
                ],
              ));
      return;
    }

    widget.onAddExpense(
      Expense(
          title: enteredTitle,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final firstDate = DateTime(
        DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
    var pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: DateTime.now());
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text('Title')),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                      prefixText: '\$', labelText: 'Amount'),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal:
                          true), // Virgülü almamak lazım buna bakkkkk!!!!!!!!
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Selected '
                        : formatter.format(_selectedDate!)),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_today)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                  iconSize: 2,
                  value: _selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase())))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _submitExpense();
                },
                child: const Text('Add Expense'),
              )
            ],
          )
        ],
      ),
    );
  }
}

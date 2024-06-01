import 'package:savetify/src/features/expense/model/expense_model.dart';
import 'package:savetify/src/features/expense/model/expense_repository.dart';

class ExpenseViewModel {
  ExpenseRepository _expenseRepository;

  ExpenseViewModel(this._expenseRepository);

  List<ExpenseModel> getExpenses() {
    return _expenseRepository.getExpenses();
  }

  void getExpensesFromFirebase() {
    _expenseRepository.getExpensesFromFirebase();
  }

  void addExpense(ExpenseModel expense) {
    _expenseRepository.addExpense(expense);
  }

  void deleteExpense(String id) {
    _expenseRepository.deleteExpense(id);
  }

  void updateExpense(ExpenseModel expense) {
    _expenseRepository.updateExpense(expense);
  }
}

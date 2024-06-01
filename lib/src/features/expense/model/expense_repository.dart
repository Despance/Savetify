import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'expense_model.dart';

class ExpenseRepository {
  final List<ExpenseModel> _expenses = [];

  ExpenseRepository();

  Future<void> getExpensesFromFirebase() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_expenses')
          .get();
      _expenses.clear();
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        double amount = (data['amount'] is int)
            ? (data['amount'] as int).toDouble()
            : data['amount'] as double;
        _expenses.add(ExpenseModel(
          id: doc.id,
          description: data['description'] ?? '',
          amount: amount,
          date: (data['date'] as Timestamp).toDate(),
          category: data['category'] ?? '',
        ));
      }
    } catch (e) {
      print('DÖNÜŞTÜRÜCÜ PROBLEMLİ');
    }
  }

  List<ExpenseModel> getExpenses() {
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    return _expenses;
  }

  void addExpense(ExpenseModel expense) {
    _expenses.add(expense);
  }

  Future<void> sendToFirebase(ExpenseModel expenseModel) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('user_expenses')
        .add({
      'amount': expenseModel.amount,
      'category': expenseModel.category,
      'date': expenseModel.date,
      'description': expenseModel.description,
    });
    expenseModel.id = snapshot.id;
    _expenses.add(expenseModel);
  }

  Future<void> sendToFirebaseUpdate(ExpenseModel expenseModel) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('user_expenses')
        .doc(expenseModel.id)
        .update({
      'amount': expenseModel.amount,
      'category': expenseModel.category,
      'date': expenseModel.date,
      'description': expenseModel.description,
    });
  }

  Future<void> deleteExpenseFromFirebase(String id) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('user_expenses')
        .doc(id)
        .delete();
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    deleteExpenseFromFirebase(id); // Firebase'den de sil
  }

  void updateExpense(ExpenseModel expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    }
  }
}

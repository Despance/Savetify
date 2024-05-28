import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';

class ExpenseRepository {
  List<ExpenseModel> _expenses = [];

  ExpenseRepository() {}

  getExpensesFromFirebase() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_expenses')
          .get();
      snapshot.docs.forEach((doc) {
        _expenses.add(ExpenseModel(
          id: doc.id,
          description: doc['description'],
          amount: doc['amount'],
          date: doc['date'].toDate(),
          category: doc['category'],
        ));
      });
    } catch (e) {
      print(e);
    }
  }

  List<ExpenseModel> getExpenses() {
    return _expenses;
  }

  void addExpense(ExpenseModel expense) {
    _expenses.add(expense);
  }

  sendToFirebase(ExpenseModel expenseModel) async {
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

  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
  }

  void updateExpense(ExpenseModel expense) {
    _expenses[_expenses.indexWhere((e) => e.id == expense.id)] = expense;
  }
}

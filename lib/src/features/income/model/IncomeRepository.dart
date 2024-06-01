import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savetify/src/features/income/model/IncomeModel.dart';

class IncomeRepository {
  List<IncomeModel> incomes = [];

  Future<void> getIncomesFromFirebase() async {
    try {
      incomes.clear(); // Clear the list to prevent duplication
      var snapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_incomes')
          .get();
      snapshot.docs.forEach((doc) {
        // Check if the income is already in the list before adding it
        var income = IncomeModel(
          id: doc.id,
          description: doc['description'],
          amount: doc['amount'],
          date: doc['date'].toDate(),
        );
        if (!incomes.any((i) => i.id == income.id)) {
          incomes.add(income);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  List<IncomeModel> getIncomes() {
    return incomes;
  }

  Future<void> addToFireBase(IncomeModel incomeModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('incomes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_incomes')
          .add({
        'amount': incomeModel.amount,
        'date': incomeModel.date,
        'description': incomeModel.description,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteIncomeFromFirebase(IncomeModel incomeModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('incomes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_incomes')
          .doc(incomeModel.id)
          .delete();
      incomes.removeWhere((i) => i.id == incomeModel.id); // Remove by ID
    } catch (e) {
      print(e);
    }
  }
}

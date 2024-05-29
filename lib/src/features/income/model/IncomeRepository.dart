import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savetify/src/features/income/model/IncomeModel.dart';

class IncomeRepository {
  List<IncomeModel> incomes = [];

  getIncomesFromFirebase() async {
    try {
      incomes.clear();
      var snapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_incomes')
          .get();
      snapshot.docs.forEach((doc) {
        incomes.add(IncomeModel(
          id: doc.id,
          description: doc['description'],
          amount: doc['amount'],
          date: doc['date'].toDate(),
        ));
      });
    } catch (e) {
      print(e);
    }
  }

  List<IncomeModel> getIncomes() {
    return incomes;
  }

  addToFireBase(IncomeModel incomeModel) async {
    try {
      var snapshot = await FirebaseFirestore.instance
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

  deleteIncomeFromFirebase(IncomeModel incomeModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('incomes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user_incomes')
          .doc(incomeModel.id)
          .delete();
      incomes.remove(incomeModel);
    } catch (e) {
      print(e);
    }
  }
}

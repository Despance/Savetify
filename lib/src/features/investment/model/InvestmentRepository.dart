import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';

class InvestmentModelRepository {
  static const String _investmentModelsKey = 'investmentModels';

  Future<List<InvestmentModel>> getInvestmentModels() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(_investmentModelsKey)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(_investmentModelsKey)
        .get();
    return snapshot.docs
        .map((doc) => InvestmentModel(
              id: doc.id,
              name: doc['name'],
              unitAmount: doc['unitAmount'],
              unitPrice: doc['unitPrice'],
              date: doc['date'],
              value: doc['value'],
            ))
        .toList();
  }

  Future<DocumentReference> saveInvestmentModels(
    InvestmentModel investmentModel) async {
      return await FirebaseFirestore.instance
          .collection(_investmentModelsKey)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(_investmentModelsKey)
          .add({
        'name': investmentModel.name,
        'unitAmount': investmentModel.unitAmount,
        'unitPrice': investmentModel.unitPrice,
        'date': investmentModel.date,
        'value': investmentModel.value,
      });
  }

  Future updateInvestmentModels(
    String index,
    InvestmentModel investmentModel) async {
      return await FirebaseFirestore.instance
          .collection(_investmentModelsKey)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(_investmentModelsKey)
          .doc(index)
          .update({
        'name': investmentModel.name,
        'unitAmount': investmentModel.unitAmount,
        'unitPrice': investmentModel.unitPrice,
        'date': investmentModel.date,
        'value': investmentModel.value,
      });
  }

  Future<void> deleteInvestmentModel(String id) async {
    await FirebaseFirestore.instance
        .collection(_investmentModelsKey)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(_investmentModelsKey)
        .doc(id)
        .delete();
  }
}

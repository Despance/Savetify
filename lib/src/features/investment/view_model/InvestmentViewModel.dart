import 'package:flutter/material.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';
import 'package:savetify/src/features/investment/model/InvestmentRepository.dart';

class InvestmentViewModel {
  final InvestmentModelRepository _repository;
  List<InvestmentModel> investmentModels = [];
  bool obscureTotalValue = false;

  InvestmentViewModel(this._repository);

  Future<void> loadInvestmentModels() async {
    investmentModels = await _repository.getInvestmentModels();
  }

  Future<void> addInvestmentModel(InvestmentModel investmentModel) async {
    var snapshot = await _repository.saveInvestmentModels(investmentModel);
    investmentModel.id = snapshot.id;
  }

  Future<void> updateInvestmentModel(String index, InvestmentModel investmentModel) async {
    await _repository.updateInvestmentModels(index, investmentModel);
  }

  Future<void> deleteInvestmentModel(int index) async {
    await _repository.deleteInvestmentModel(investmentModels[index].id!);
  }

  double getTotalInvestmentModelsValue() {
    double total = 0.0;
    for (var investmentModel in investmentModels) {
      total += double.parse(investmentModel.value);
    }
    return total;
  }

  void toggleTotalValueVisibility() {
    obscureTotalValue = !obscureTotalValue;
  }
}

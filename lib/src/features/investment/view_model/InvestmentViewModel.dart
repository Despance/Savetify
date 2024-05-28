import 'package:flutter/material.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';
import 'package:savetify/src/features/investment/model/InvestmentRepository.dart';

class InvestmentViewModel extends ChangeNotifier {
  final InvestmentModelRepository _repository;
  List<InvestmentModel> investmentModels = [];
  bool obscureTotalValue = false;

  InvestmentViewModel(this._repository);

  Future<void> loadInvestmentModels() async {
    investmentModels = await _repository.getInvestmentModels();
    notifyListeners();
  }

  Future<void> addInvestmentModel(InvestmentModel investmentModel) async {
    investmentModels.add(investmentModel);
    await _repository.saveInvestmentModels(investmentModels);
    notifyListeners();
  }

  Future<void> updateInvestmentModel(int index, InvestmentModel investmentModel) async {
    investmentModels[index] = investmentModel;
    await _repository.saveInvestmentModels(investmentModels);
    notifyListeners();
  }

  Future<void> deleteInvestmentModel(int index) async {
    investmentModels.removeAt(index);
    await _repository.saveInvestmentModels(investmentModels);
    notifyListeners();
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
    notifyListeners();
  }
}

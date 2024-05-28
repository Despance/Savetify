import 'dart:convert';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentModelRepository {
  static const String _investmentModelsKey = 'investmentModels';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<InvestmentModel>> getInvestmentModels() async {
    final investmentModelList = _prefs.getStringList(_investmentModelsKey) ?? [];
    return investmentModelList
        .map((json) => InvestmentModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveInvestmentModels(List<InvestmentModel> investmentModels) async {
    final List<String> investmentModelStrings =
        investmentModels.map((investmentModel) => jsonEncode(investmentModel.toJson())).toList();
    await _prefs.setStringList(_investmentModelsKey, investmentModelStrings);
  }
}

import 'package:savetify/src/features/investment/model/InvestmentModel.dart';

class PortfolioModel {
  String _userId = '';
  String _portfolioName = '';
  String _portfolioId = '';
  List<InvestmentModel> _investments = [];

  PortfolioModel.create(String userId, String portfolioName, String portfolioId,
      List<InvestmentModel> investments) {
    _userId = userId;
    _portfolioName = portfolioName;
    _portfolioId = portfolioId;
    _investments = investments;
  }

  void addInvestment(InvestmentModel investment) {
    _investments.add(investment);
  }

  String get userId => _userId;
  String get portfolioName => _portfolioName;
  String get portfolioId => _portfolioId;
  List<InvestmentModel> get investments => _investments;

  
}

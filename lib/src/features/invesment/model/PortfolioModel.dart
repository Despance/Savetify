import 'package:savetify/src/features/invesment/model/InvestmentModel.dart';

class PortfolioModel {
  final String _portfolioName;
  List<InvestmentModel> investments = [
    InvestmentModel(name: "stockA", price: 42.69, dateOfPurchase: DateTime(2020,2,1 ), quantity: 5.2),
    InvestmentModel(name: "stockB", price: 36.99, dateOfPurchase: DateTime(2021,3,5), quantity: 6.4),
    InvestmentModel(name: "CryptoC", price: 15.15, dateOfPurchase: DateTime(2022,5,8), quantity: 15.15),
    ];
  PortfolioModel({required String portfolioName}) : _portfolioName = portfolioName;
  List<InvestmentModel> get getInvestments => investments;
  String get getPortfolioName => _portfolioName;
}
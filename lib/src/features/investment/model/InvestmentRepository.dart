import 'package:savetify/src/features/investment/model/InvestmentModel.dart';
import 'package:savetify/src/features/investment/model/PortfolioModel.dart';

class InvestmentRepository {
  List<PortfolioModel> portfolios = [];

  InvestmentRepository();

  InvestmentRepository.create(String userId) {
    // TODO: fetch portfolios from database
    return;
  }

  List<PortfolioModel> getPortfolios() {
    return portfolios;
  }

  List<InvestmentModel> getInvestments(String portfolioId) {
    for (var portfolio in portfolios) {
      if (portfolio.portfolioId == portfolioId) {
        return portfolio.investments;
      }
    }

    throw Exception('Portfolio not found');
    
  }
}

import 'package:savetify/src/features/invesment/model/PortfolioModel.dart';
import 'package:savetify/src/features/report/model/InvestmentData.dart';
import 'package:savetify/src/features/report/model/ReportModel.dart';

class ReportRepository {
  final List<ReportModel> _reportModel = [
    ReportModel.createReport('Report 1', 'Description 1', DateTime.now(),
        DateTime.now(), [PortfolioModel(portfolioName: 'Portfolio 1')]),
    ReportModel.createReport('Report 2', 'Description 2', DateTime.now(),
        DateTime.now(), [PortfolioModel(portfolioName: 'Portfolio 2')]),
    ReportModel.createReport('Report 3', 'Description 3', DateTime.now(),
        DateTime.now(), [PortfolioModel(portfolioName: 'Portfolio 3')])
  ];
  final List<InvestmentData> _investmentDataList = [
    InvestmentData(
      name: 'StockA',
      priceOverTime: [
        DataOverTime(date: DateTime(2021, 1, 1), price: 100),
        DataOverTime(date: DateTime(2021, 1, 2), price: 200),
        DataOverTime(date: DateTime(2021, 1, 3), price: 300),
        DataOverTime(date: DateTime(2021, 1, 4), price: 400),
        DataOverTime(date: DateTime(2021, 1, 5), price: 500),
      ],
    ),
    InvestmentData(
      name: 'StockB',
      priceOverTime: [
        DataOverTime(date: DateTime(2021, 1, 1), price: 100),
        DataOverTime(date: DateTime(2021, 1, 2), price: 200),
        DataOverTime(date: DateTime(2021, 1, 3), price: 300),
        DataOverTime(date: DateTime(2021, 1, 4), price: 400),
        DataOverTime(date: DateTime(2021, 1, 5), price: 500),
      ],
    ),
    InvestmentData(
      name: 'CryptoC',
      priceOverTime: [
        DataOverTime(date: DateTime(2021, 1, 1), price: 100),
        DataOverTime(date: DateTime(2021, 1, 2), price: 200),
        DataOverTime(date: DateTime(2021, 1, 3), price: 300),
        DataOverTime(date: DateTime(2021, 1, 4), price: 400),
        DataOverTime(date: DateTime(2021, 1, 5), price: 500),
      ],
    ),
  ];
  //TODO: do this properly
  List<PortfolioModel> getPortfolios() {
    return [
      PortfolioModel(portfolioName: 'Portfolio 1'),
      PortfolioModel(portfolioName: 'Portfolio 2'),
      PortfolioModel(portfolioName: 'Portfolio 3')
    ];
  }

  InvestmentData getInvestmentData(String investmentName) {
    return _investmentDataList
        .firstWhere((investmentData) => investmentData.name == investmentName);
  }

  List<InvestmentData> getPortfolioInvestmentData(
      int reportIndex, String portfolioName) {
    return _reportModel[reportIndex]
        .portfolios
        .firstWhere((portfolio) => portfolio.getPortfolioName == portfolioName)
        .getInvestments
        .map(
          (investment) => InvestmentData(
            name: investment.name,
            priceOverTime: _investmentDataList
                .firstWhere((element) => element.name == investment.name)
                .priceOverTime,
          ),
        )
        .toList();
  }

  getReports() {
    return _reportModel;
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/invesment/model/InvestmentModel.dart';
import 'package:savetify/src/features/invesment/model/PortfolioModel.dart';
import 'package:savetify/src/features/report/model/GraphData.dart';
import 'package:savetify/src/features/report/model/InvestmentData.dart';
import 'package:savetify/src/features/report/model/ReportModel.dart';
import 'package:savetify/src/features/report/model/ReportRepository.dart';

class ReportViewModel {
  List<ReportModel> _reportModel = [];
  late ReportRepository _reportRepository;

  ReportViewModel();
  ReportViewModel.retrieveReports(this._reportRepository) {
    _reportModel = _reportRepository.getReports();
  }

  initiliazeReportRepository() {
    _reportRepository = ReportRepository();
  }

  List<PortfolioModel> getPortfolios() {
    if (_reportRepository.getPortfolios().isEmpty) {
      return [];
    }
    return _reportRepository.getPortfolios();
  }

  PortfolioModel getPortfolio(int reportIndex, String portfolioName) {
    return _reportRepository
        .getPortfolios()
        .firstWhere((portfolio) => portfolio.getPortfolioName == portfolioName);
  }

  void addReport(String title, String description, DateTime startingDate,
      DateTime endingDate, List<PortfolioModel> portfolios) {
    ReportModel newReport = ReportModel.createReport(
        title, description, startingDate, endingDate, portfolios);
    _reportModel.add(newReport);
  }

  void setTitle(int index, String title) {
    _reportModel.elementAt(index).setTitle(title);
  }

  void setDescription(int index, String description) {
    _reportModel.elementAt(index).setDescription(description);
  }

  String getTitle(int index) {
    if (_reportModel.isEmpty) {
      return '';
    }
    return _reportModel.elementAt(index).title;
  }

  String getDescription(int index) {
    if (_reportModel.isEmpty) {
      return '';
    }
    return _reportModel.elementAt(index).description;
  }

  DateTime getStartingDate(int index) {
    if (_reportModel.isEmpty) {
      return DateTime.now();
    }
    return _reportModel.elementAt(index).reportSartingDateTime;
  }

  DateTime getEndingDate(int index) {
    if (_reportModel.isEmpty) {
      return DateTime.now();
    }
    return _reportModel.elementAt(index).reportEndingDateTime;
  }

  DateTime getCreationDate(int index) {
    if (_reportModel.isEmpty) {
      return DateTime.now();
    }
    return _reportModel.elementAt(index).creationDateTime;
  }

  List<InvestmentData> getAllInvestmentData() {
    return _reportRepository.getAllInvestmentData();
  }

  List<GraphData> getGraphDataForInvestment(
      int reportIndex, String portfolioName, String investmentName) {
    List<InvestmentData> investmentDatas = getAllInvestmentData();
    InvestmentData investmentData = InvestmentData(name: '', priceOverTime: []);

    int investmentDatasLength = investmentDatas.length;
    for (var i = 0; i < investmentDatasLength; i++) {
      if (investmentDatas[i].name == investmentName) {
        investmentData = investmentDatas[i];
        break;
      }
    }
    InvestmentModel investmentModel = getPortfolio(reportIndex, portfolioName)
        .getInvestments
        .firstWhere((element) => element.name == investmentName);

    List<GraphData> graphData = [];
    int investmentDataLength = investmentData.priceOverTime.length;
    for (int i = 0; i < investmentDataLength; i++) {
      if (investmentModel.dateOfPurchase
          .isBefore(investmentData.priceOverTime[i].date)) {
        if (investmentModel.price != 0) {
          graphData.add(GraphData(
              date: investmentData.priceOverTime[i].date,
              spot: FlSpot(
                  investmentData.priceOverTime[i].date
                      .difference(investmentModel.dateOfPurchase)
                      .inDays
                      .toDouble(),
                  investmentData.priceOverTime[i].price *
                      investmentModel.quantity *
                      investmentModel.price)));
        }
      }
    }

    return graphData;
  }

  getExpenseForTime(DateTime startingDate, DateTime endingDate) {
    // List<ExpenseModel> expenses = _reportRepository.getAllInvestmentData()
    List<ExpenseModel> newExpenses = [];
    for (ExpenseModel expense in newExpenses) {
      if (expense.date.isAfter(startingDate) &&
          expense.date.isBefore(endingDate)) {
        newExpenses.add(expense);
      }
    }
    return newExpenses;
  }

  List<ReportModel> get getReports => _reportModel;

  int get length {
    return _reportModel.length;
  }
}

import 'package:savetify/src/features/invesment/model/PortfolioModel.dart';
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

  List<PortfolioModel> getPortfolios() {
    if (_reportRepository.getPortfolios().isEmpty) {
      return [];
    }
    return _reportRepository.getPortfolios();
  }
  PortfolioModel getPortfolio(int reportIndex, String portfolioName) {
    return _reportRepository.getPortfolios().firstWhere((portfolio) => portfolio.getPortfolioName == portfolioName);
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

  List<InvestmentData> getPortfolioInvestmentData(
      int reportIndex, String portfolioName) {
    return _reportRepository.getPortfolioInvestmentData(reportIndex, portfolioName);
  }

  List<ReportModel> get getReports => _reportModel;

  int get length {
    return _reportModel.length;
  }
}

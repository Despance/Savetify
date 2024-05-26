import 'package:savetify/src/features/invesment/model/PortfolioModel.dart';
import 'package:savetify/src/features/report/model/InvestmentData.dart';

class ReportModel {
  String userId = '';
  String reportId = '';
  String title = '';
  String description = '';
  DateTime creationDateTime = DateTime.now();
  DateTime reportSartingDateTime = DateTime.now();
  DateTime reportEndingDateTime = DateTime.now();
  List<PortfolioModel> portfolios = [];

  ReportModel();
  
  ReportModel.createReport(this.title, this.description,
      this.reportSartingDateTime, this.reportEndingDateTime, this.portfolios);

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
  }

  List<PortfolioModel> get getPortfolios => portfolios;
}

import 'package:cloud_firestore/cloud_firestore.dart';
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
  // TODO: 
  saveReport() {
    try{
      FirebaseFirestore.instance.collection('userReports').doc('User').collection('reports').add({
        'userId': userId,
        'title': title,
        'description': description,
        'creationDateTime': creationDateTime,
        'reportSartingDateTime': reportSartingDateTime,
        'reportEndingDateTime': reportEndingDateTime,
        'portfolios': portfolios
      });
      
    }
    catch (e) {
      print(e);
    }
  }

  List<PortfolioModel> get getPortfolios => portfolios;
}

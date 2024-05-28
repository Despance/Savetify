import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/invesment/model/InvestmentModel.dart';
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
        DataOverTime(date: DateTime(2020, 1, 1), price: 100),
        DataOverTime(date: DateTime(2021, 1, 2), price: 200),
        DataOverTime(date: DateTime(2022, 1, 3), price: 300),
        DataOverTime(date: DateTime(2023, 1, 4), price: 400),
        DataOverTime(date: DateTime(2024, 1, 5), price: 500),
      ],
    ),
    InvestmentData(
      name: 'StockB',
      priceOverTime: [
        DataOverTime(date: DateTime(2020, 1, 1), price: 100),
        DataOverTime(date: DateTime(2021, 1, 2), price: 200),
        DataOverTime(date: DateTime(2022, 1, 3), price: 300),
        DataOverTime(date: DateTime(2023, 1, 4), price: 400),
        DataOverTime(date: DateTime(2024, 1, 5), price: 500),
      ],
    ),
    InvestmentData(
      name: 'CryptoC',
      priceOverTime: [
        DataOverTime(date: DateTime(2020, 1, 1), price: 100),
        DataOverTime(date: DateTime(2021, 1, 2), price: 200),
        DataOverTime(date: DateTime(2022, 1, 3), price: 300),
        DataOverTime(date: DateTime(2023, 1, 4), price: 400),
        DataOverTime(date: DateTime(2024, 1, 5), price: 500),
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

  List<ExpenseModel> getExpenses() {
    return [
      ExpenseModel(
          name: 'Expense 1',
          description: '',
          id: '1',
          amount: 100,
          date: DateTime(2020, 1, 2),
          category: 'Category 1'),
      ExpenseModel(
          name: 'Expense 2',
          description: '',
          id: '1',
          amount: 200,
          date: DateTime(2020, 5, 2),
          category: 'Category 2'),
      ExpenseModel(
          name: 'Expense 3',
          description: '',
          id: '1',
          amount: 300,
          date: DateTime(2021, 1, 2),
          category: 'Category 3'),
    ];
  }

  retrieveDataFromFirebase(String userId) {
    try {
      FirebaseFirestore.instance
          .collection('userReports')
          .doc(userId)
          .collection('');
    } catch (e) {
      print(e);
    }
  }

  InvestmentData getInvestmentData(String investmentName) {
    return _investmentDataList
        .firstWhere((investmentData) => investmentData.name == investmentName);
  }

  List<InvestmentData> getAllInvestmentData() {
    return _investmentDataList;
  }

  getReports() {
    return _reportModel;
  }
}

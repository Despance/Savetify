import 'package:savetify/src/features/investment/model/InvestmentTimeData.dart';

class InvestmentModel {
  String _userId = '';
  String _investmentId = '';
  String _name = '';
  double _unitAmount = 0.0;
  double _totalValue = 0.0;
  double _unitPrice = 0.0;
  DateTime _date = DateTime.now();
  String _selectedType = 'Unit Amount';
  List<InvestmentTimeData> _priceOverTime = [];

  InvestmentModel.create(
      String userId,
      String investmentId,
      String name,
      double unitAmount,
      double totalValue,
      double unitPrice,
      DateTime date,
      String selectedType,
      List<InvestmentTimeData> priceOverTime) {
    _userId = userId;
    _investmentId = investmentId;
    _name = name;
    _unitAmount = unitAmount;
    _totalValue = totalValue;
    _unitPrice = unitPrice;
    _date = date;
    _selectedType = selectedType;
    _priceOverTime = priceOverTime;
  }

  List<InvestmentTimeData> get priceOverTime => _priceOverTime;
  String get userId => _userId;
}

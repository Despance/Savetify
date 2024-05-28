class DataOverTime {
  final DateTime date;
  final double price;

  DataOverTime({
    required this.date,
    required this.price,
  });
}

class InvestmentTimeData {
  final String name;
  final List<DataOverTime> priceOverTime;


  InvestmentTimeData({
    required this.name,
    required this.priceOverTime,
  });
}
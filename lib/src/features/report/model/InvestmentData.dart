class DataOverTime {
  final DateTime date;
  final double price;

  DataOverTime({
    required this.date,
    required this.price,
  });
}

class InvestmentData {
  final String name;
  final List<DataOverTime> priceOverTime;


  InvestmentData({
    required this.name,
    required this.priceOverTime,
  });
}
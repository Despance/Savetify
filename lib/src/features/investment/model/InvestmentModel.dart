class InvestmentModel {
  String name;
  String unitAmount;
  String unitPrice;
  String date;
  String value;

  InvestmentModel({
    required this.name,
    required this.unitAmount,
    required this.unitPrice,
    required this.date,
    required this.value,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      name: json['name'],
      unitAmount: json['unitAmount'],
      unitPrice: json['unitPrice'],
      date: json['date'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unitAmount': unitAmount,
      'unitPrice': unitPrice,
      'date': date,
      'value': value,
    };
  }
}

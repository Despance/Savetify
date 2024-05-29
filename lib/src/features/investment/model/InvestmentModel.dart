class InvestmentModel {
  String? id;
  String name;
  String unitAmount;
  String unitPrice;
  String date;
  String value;

  InvestmentModel({
    this.id,
    required this.name,
    required this.unitAmount,
    required this.unitPrice,
    required this.date,
    required this.value,
  });
}

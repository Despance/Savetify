class IncomeModel {
  String? id;
  final String description;
  final double amount;
  final DateTime date;

  IncomeModel({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
  });
}

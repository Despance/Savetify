class ExpenseModel {
  String id;
  String name;
  String description;
  double amount;
  DateTime date;
  String category;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });
}

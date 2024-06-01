class ExpenseModel {
  String? id;
  String description;
  double amount;
  DateTime date;
  String category;

  ExpenseModel({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });

  get getAmount => amount;
  get getCategory => category;
  get getDate => date;
  get getDescription => description;
  get getId => id;
}

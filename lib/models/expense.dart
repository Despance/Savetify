import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category {
  food,
  transportation,
  housing,
  entertainment,
  subscriptions,
  other,
}

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.transportation: Icons.directions_car,
  Category.housing: Icons.house,
  Category.entertainment: Icons.celebration,
  Category.subscriptions: Icons.subscriptions,
  Category.other: Icons.category,
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  get formattedDate {
    return formatter.format(date);
  }
}

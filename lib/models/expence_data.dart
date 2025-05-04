// ignore_for_file: constant_identifier_names

import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

var formater = DateFormat('d - M - yyyy');
const uuid = Uuid();

enum Category {
  Food,
  Work,
  Leisure,
  Travel,
  Utilities,
  Health,
  Shopping,
  Education,
  Entertainment,
  Miscellaneous,
}

const Map<Category, IconData> categoryIcons = {
  Category.Food: Icons.fastfood,
  Category.Work: Icons.work,
  Category.Travel: Icons.flight,
  Category.Leisure: Icons.sports_esports,
  Category.Utilities: Icons.lightbulb,
  Category.Health: Icons.local_hospital,
  Category.Shopping: Icons.shopping_cart,
  Category.Education: Icons.school,
  Category.Entertainment: Icons.movie,
  Category.Miscellaneous: Icons.more_horiz,
};

class ExpenceData {
  ExpenceData({
    String? id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final double amount;
  final Category category;
  final DateTime date;

  String getFormatedDate() {
    return formater.format(date);
  }
}

class ExpenceBucketCategory {
  const ExpenceBucketCategory(
      {required this.category, required this.expenceList});

  ExpenceBucketCategory.forCategory(
      List<ExpenceData> allExpences, this.category)
      : expenceList = allExpences
            .where((expence) => (expence.category == category))
            .toList();

  final Category category;
  final List<ExpenceData> expenceList;

  double getTotalExpence() {
    double sum = 0.0;
    for (final expence in expenceList) {
      sum += expence.amount;
    }
    return sum;
  }
}

class ExpenceBucketMonth {
  const ExpenceBucketMonth({required this.month, required this.expenceList});

  ExpenceBucketMonth.forMonth(List<ExpenceData> allExpences, this.month)
      : expenceList = allExpences
            .where((expence) =>
                (ExpenceBucketMonth.getMonth(expence.date) == month))
            .toList();

  final int month;
  final List<ExpenceData> expenceList;

  static int getMonth(DateTime selectedDate) {
    int month = selectedDate.month;
    return month;
  }

  double getTotalExpence() {
    double sum = 0.0;
    for (final expence in expenceList) {
      sum += expence.amount;
    }
    return sum;
  }
}

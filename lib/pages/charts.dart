import 'package:expence_tracker/models/chart_category/chart.dart';
import 'package:expence_tracker/models/chart_month/chart.dart';
import 'package:expence_tracker/models/expence_data.dart';
import 'package:flutter/material.dart';

class Charts extends StatelessWidget {
  const Charts({super.key, required this.expenceList});

  final List<ExpenceData> expenceList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Chart(expenses: expenceList)),
          SizedBox(
            height: 30,
          ),
          SizedBox(height: 380, child: ChartMonth(expenses: expenceList)),
        ],
      ),
    );
  }
}

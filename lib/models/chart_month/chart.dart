import 'package:flutter/material.dart';

import 'package:expence_tracker/models/chart_category/chart_bar.dart';
import 'package:expence_tracker/models/expence_data.dart';

class ChartMonth extends StatelessWidget {
  const ChartMonth({super.key, required this.expenses});

  final List<ExpenceData> expenses;

  List<ExpenceBucketMonth> get buckets {
    return [
      ExpenceBucketMonth.forMonth(expenses, 1),
      ExpenceBucketMonth.forMonth(expenses, 2),
      ExpenceBucketMonth.forMonth(expenses, 3),
      ExpenceBucketMonth.forMonth(expenses, 4),
      ExpenceBucketMonth.forMonth(expenses, 5),
      ExpenceBucketMonth.forMonth(expenses, 6),
      ExpenceBucketMonth.forMonth(expenses, 7),
      ExpenceBucketMonth.forMonth(expenses, 8),
      ExpenceBucketMonth.forMonth(expenses, 9),
      ExpenceBucketMonth.forMonth(expenses, 10),
      ExpenceBucketMonth.forMonth(expenses, 11),
      ExpenceBucketMonth.forMonth(expenses, 12),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.getTotalExpence() > maxTotalExpense) {
        maxTotalExpense = bucket.getTotalExpence();
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: Color.fromARGB(255, 199, 232, 171),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final bucket in buckets) // alternative to map()
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Theme.of(context).cardColor,
                      ),
                      alignment: Alignment.bottomCenter,
                      height: double.infinity,
                      width: 20,
                      child: ChartBar(
                        fill: bucket.getTotalExpence() == 0
                            ? 0
                            : bucket.getTotalExpence() / maxTotalExpense,
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (final month in months)
                Text(
                  month,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color),
                )
            ])
          ],
        ),
      ),
    );
  }
}

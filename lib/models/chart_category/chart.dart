// import 'package:flutter/material.dart';

// import 'package:expence_tracker/models/chart_category/chart_bar.dart';
// import 'package:expence_tracker/models/expence_data.dart';

// class Chart extends StatelessWidget {
//   const Chart({super.key, required this.expenses});

//   final List<ExpenceData> expenses;

//   List<ExpenceBucketCategory> get buckets {
//     return [
//       ExpenceBucketCategory.forCategory(expenses, Category.Food),
//       ExpenceBucketCategory.forCategory(expenses, Category.Leisure),
//       ExpenceBucketCategory.forCategory(expenses, Category.Travel),
//       ExpenceBucketCategory.forCategory(expenses, Category.Work),
//     ];
//   }

//   double get maxTotalExpense {
//     double maxTotalExpense = 0;

//     for (final bucket in buckets) {
//       if (bucket.getTotalExpence() > maxTotalExpense) {
//         maxTotalExpense = bucket.getTotalExpence();
//       }
//     }

//     return maxTotalExpense;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
//       child: Container(
//         padding: EdgeInsets.all(10),
//         width: double.infinity,
//         height: 250,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Color.fromARGB(255, 199, 232, 171),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   for (final bucket in buckets) // alternative to map()
//                     ChartBar(
//                       fill: bucket.getTotalExpence() == 0
//                           ? 0
//                           : bucket.getTotalExpence() / maxTotalExpense,
//                     )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               children: buckets
//                   .map(
//                     (bucket) => Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4),
//                         child: Icon(
//                           categoryIcons[bucket.category],
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   )
//                   .toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expence_tracker/models/expence_data.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<ExpenceData> expenses;

  // Define colors for each category
  static final Map<Category, Color> categoryColors = {
    Category.Food: const Color.fromARGB(255, 164, 195, 98),
    Category.Work: const Color.fromARGB(255, 156, 156, 150),
    Category.Travel: const Color.fromARGB(255, 255, 115, 118),
    Category.Leisure: const Color.fromARGB(255, 255, 168, 82),
  };

  List<ExpenceBucketCategory> get buckets {
    return [
      ExpenceBucketCategory.forCategory(expenses, Category.Food),
      ExpenceBucketCategory.forCategory(expenses, Category.Leisure),
      ExpenceBucketCategory.forCategory(expenses, Category.Travel),
      ExpenceBucketCategory.forCategory(expenses, Category.Work),
    ];
  }

  double get totalExpenses {
    return buckets.fold(0.0, (sum, bucket) => sum + bucket.getTotalExpence());
  }

  List<PieChartSectionData> get pieSections {
    if (totalExpenses == 0) {
      return [];
    }

    return buckets.map((bucket) {
      final value = bucket.getTotalExpence();
      return PieChartSectionData(
        color: categoryColors[bucket.category],
        value: value,
        title: '${(value / totalExpenses * 100).toStringAsFixed(1)}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                duration: Duration(milliseconds: 500),
                PieChartData(
                  sections: pieSections,
                  sectionsSpace: 5,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                iconData(
                    context,
                    Icon(
                      Icons.lunch_dining,
                      color: const Color.fromARGB(255, 164, 195, 98),
                    ),
                    "Food"),
                iconData(
                    context,
                    Icon(
                      Icons.work,
                      color: const Color.fromARGB(255, 156, 156, 150),
                    ),
                    "Work"),
                iconData(
                    context,
                    Icon(
                      Icons.flight_takeoff,
                      color: const Color.fromARGB(255, 255, 115, 118),
                    ),
                    "Travel"),
                iconData(
                    context,
                    Icon(
                      Icons.movie,
                      color: const Color.fromARGB(255, 255, 168, 82),
                    ),
                    "Leisure"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget iconData(BuildContext context, Icon icon, String label) {
  return Column(
    children: [
      icon,
      SizedBox(
        height: 2,
      ),
      Text(
        label,
        style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).textTheme.titleMedium?.color),
      ),
    ],
  );
}

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
    Category.Food: const Color.fromARGB(255, 75, 192, 192), // Teal
    Category.Work: const Color.fromARGB(255, 163, 130, 207), // Purple
    Category.Travel: const Color.fromARGB(255, 255, 99, 132), // Pink
    Category.Leisure: const Color.fromARGB(255, 255, 159, 64), // Orange
    Category.Utilities: const Color.fromARGB(255, 54, 162, 235), // Blue
    Category.Health: const Color.fromARGB(255, 220, 20, 160), // Magenta
    Category.Shopping: const Color.fromARGB(255, 255, 205, 86), // Yellow
    Category.Education: const Color.fromARGB(255, 106, 27, 154), // Deep Purple
    Category.Entertainment: const Color.fromARGB(255, 239, 83, 27), // Coral
    Category.Miscellaneous:
        const Color.fromARGB(255, 96, 125, 139), // Blue Gray
  };

  List<ExpenceBucketCategory> get buckets {
    return Category.values.map((category) {
      return ExpenceBucketCategory.forCategory(expenses, category);
    }).toList();
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
        showTitle: false,
        color: categoryColors[bucket.category],
        value: value,
        radius: 70,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: Category.values.map((category) {
                    return iconData(
                      context,
                      Icon(
                        categoryIcons[category],
                        color: categoryColors[category],
                      ),
                      category.name,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget iconData(BuildContext context, Icon icon, String label) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          icon,
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
      SizedBox(
        width: 20,
      )
    ],
  );
}

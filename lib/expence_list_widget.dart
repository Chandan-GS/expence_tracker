import 'package:expence_tracker/models/expence_data.dart';
import 'package:flutter/material.dart';

class ExpenceListWidget extends StatelessWidget {
  const ExpenceListWidget({super.key, required this.expences});

  final ExpenceData expences;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expences.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  '₹ ${expences.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(
                      categoryIcons[expences.category],
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      expences.getFormatedDate(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

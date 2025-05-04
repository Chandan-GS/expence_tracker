import 'package:expence_tracker/expence_list_widget.dart';
import 'package:expence_tracker/models/expence_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenceList extends StatelessWidget {
  const ExpenceList(
      {super.key, required this.expence, required this.onRemoveExpence});

  final List<ExpenceData> expence;
  final Function(ExpenceData expence) onRemoveExpence;

  Map<String, List<ExpenceData>> _groupExpensesByMonth() {
    final groupedExpenses = <String, List<ExpenceData>>{};

    // Sort expenses by date in descending order
    final sortedExpenses = List<ExpenceData>.from(expence)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (var expense in sortedExpenses) {
      final date = expense.date;
      final monthYear = DateFormat('MMMM yyyy').format(date);

      if (!groupedExpenses.containsKey(monthYear)) {
        groupedExpenses[monthYear] = [];
      }
      groupedExpenses[monthYear]!.add(expense);
    }

    return groupedExpenses;
  }

  Widget _buildDismissibleBackground() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(
        color: const Color.fromARGB(255, 255, 93, 81),
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (expence.isEmpty) {
      return const Center(
        child: Text('No expenses added yet'),
      );
    }

    final groupedExpenses = _groupExpensesByMonth();

    return ListView.builder(
      itemCount: groupedExpenses.length,
      itemBuilder: (context, index) {
        final monthYear = groupedExpenses.keys.elementAt(index);
        final monthExpenses = groupedExpenses[monthYear]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                monthYear,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...monthExpenses
                .map((expense) => Dismissible(
                      direction: DismissDirection.endToStart,
                      key: ValueKey(expense),
                      background: _buildDismissibleBackground(),
                      onDismissed: (direction) async {
                        try {
                          debugPrint('Deleting expense with ID: ${expense.id}');
                          onRemoveExpence(expense);
                        } catch (e) {
                          debugPrint('Error in dismissible: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error deleting expense')),
                            );
                          }
                        }
                      },
                      child: ExpenceListWidget(expences: expense),
                    ))
                .toList(),
          ],
        );
      },
    );
  }
}

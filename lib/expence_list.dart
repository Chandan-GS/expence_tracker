import 'package:expence_tracker/expence_list_widget.dart';
import 'package:expence_tracker/models/expence_data.dart';
import 'database_service.dart';
import 'package:flutter/material.dart';

class ExpenceList extends StatelessWidget {
  const ExpenceList(
      {super.key, required this.expence, required this.onRemoveExpence});

  final List<ExpenceData> expence;
  final Function(ExpenceData expence) onRemoveExpence;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expence.length,
      itemBuilder: (cxt, index) => Dismissible(
        direction: DismissDirection.endToStart,
        key: ValueKey(expence[index]),
        background: Padding(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Card(
            color: const Color.fromARGB(255, 255, 93, 81),
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        onDismissed: (direction) async {
          try {
            final removedItem = expence[index];
            debugPrint('Deleting expense with ID: ${removedItem.id}');
            onRemoveExpence(removedItem);
          } catch (e) {
            debugPrint('Error in dismissible: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error deleting expense')),
            );
          }
        },
        child: ExpenceListWidget(expences: expence[index]),
      ),
    );
  }
}

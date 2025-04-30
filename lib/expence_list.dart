import 'package:expence_tracker/expence_list_widget.dart';
import 'package:expence_tracker/models/expence_data.dart';
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
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          final removedItem = expence[index];
          onRemoveExpence(removedItem);
        },
        child: ExpenceListWidget(expences: expence[index]),
      ),
    );
  }
}

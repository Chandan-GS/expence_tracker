import 'package:expence_tracker/database_service.dart';
import 'package:flutter/material.dart';
import 'package:expence_tracker/models/expence_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key, required this.onaddExpences});

  final Function(ExpenceData) onaddExpences;

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final TextEditingController _textEditingTitle = TextEditingController();
  final TextEditingController _textEditingAmount = TextEditingController();
  DateTime? selectedDate;
  Category _selectedCategory = Category.Food;

  @override
  void dispose() {
    _textEditingTitle.dispose();
    _textEditingAmount.dispose();
    super.dispose();
  }

  void _submitExpenseData() async {
    final _amount = double.tryParse(_textEditingAmount.text);
    if (_textEditingTitle.text.trim().isEmpty ||
        _amount == null ||
        _amount <= 0 ||
        selectedDate == null) {
      showDialog(
        context: context,
        builder: (cxt) => AlertDialog(
          content: Text(
              "Please make sure a valid date, title and amount were entered."),
          title: Text("Invalid input"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(cxt),
              child: Text("Okay"),
            )
          ],
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId != null) {
      final expense = ExpenceData(
        title: _textEditingTitle.text,
        amount: _amount,
        category: _selectedCategory,
        date: selectedDate!,
      );

      await DatabaseService.instance.addExpense(userId, expense);
      widget.onaddExpences(expense);
    }

    Navigator.pop(context);
  }

  void _showDate() async {
    final pickedDate = await showDatePicker(
        initialDate: DateTime.now(),
        context: context,
        firstDate: DateTime(
            DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime.now());

    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  ExpenceData addExpence(double _amount) {
    return ExpenceData(
        title: _textEditingTitle.text,
        amount: _amount,
        category: _selectedCategory,
        date: selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    String defaultDate = formater.format(DateTime.now());
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor, blurRadius: 50)
          ],
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      width: 600,
      height: 700,
      padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          TextField(
            controller: _textEditingTitle,
            style: TextStyle(fontWeight: FontWeight.w500),
            maxLength: 25,
            decoration: _inputDecor(context, "Title", ""),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingAmount,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  decoration: _inputDecor(
                    context,
                    "Amount",
                    "₹ ",
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                height: 56,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      width: 0.4,
                      color: const Color.fromARGB(255, 124, 124, 124),
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      selectedDate == null
                          ? defaultDate
                          : formater.format(selectedDate!),
                    ),
                    IconButton(
                      onPressed: () => _showDate(),
                      icon: Icon(Icons.calendar_month),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Category",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: Category.values.map((category) {
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                showCheckmark: false,
                checkmarkColor: Colors.white,
                label: Text(category.name),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).cardColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // No rounded corners
                  ),
                  backgroundColor: const Color.fromARGB(
                      255, 255, 170, 164), // Background color
                ),
                onPressed: _cancel,
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // No rounded corners
                  ),
                  backgroundColor: const Color.fromARGB(
                      255, 161, 255, 155), // Background color
                ),
                onPressed: () {
                  _submitExpenseData();
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecor(
    BuildContext context, String hintText, String prefix) {
  return InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      hintStyle: TextStyle(color: const Color.fromARGB(255, 130, 130, 130)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0), // Black border when enabled
      ),
      label: Text(
        hintText,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      filled: true,
      fillColor: Theme.of(context).cardColor,
      prefixText: prefix);
}

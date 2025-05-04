import 'package:expence_tracker/database_service.dart';
import 'package:expence_tracker/expence_list.dart';
import 'package:expence_tracker/models/expence_data.dart';
import 'package:expence_tracker/models/side_bar.dart';
import 'package:expence_tracker/pages/bottom_sheet.dart';
import 'package:expence_tracker/pages/charts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expences extends StatefulWidget {
  const Expences({
    super.key,
    required this.screen,
  });

  final String screen;

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  List<ExpenceData> expenceList = [
    // ExpenceData(
    //   title: "Groceries",
    //   amount: 50.0,
    //   category: Category.Food,
    //   date: DateTime.now().subtract(Duration(days: 1)),
    // ),
    // ExpenceData(
    //   title: "Electricity Bill",
    //   amount: 75.0,
    //   category: Category.Work,
    //   date: DateTime.now().subtract(Duration(days: 3)),
    // ),
    // ExpenceData(
    //   title: "Gym Membership",
    //   amount: 30.0,
    //   category: Category.Travel,
    //   date: DateTime.now().subtract(Duration(days: 7)),
    // ),
    // ExpenceData(
    //   title: "Movie Tickets",
    //   amount: 20.0,
    //   category: Category.Lesiure,
    //   date: DateTime.now().subtract(Duration(days: 200)),
    // ),
    // ExpenceData(
    //   title: "Coffee",
    //   amount: 5.0,
    //   category: Category.Food,
    //   date: DateTime.now().subtract(Duration(days: 30)),
    // ),
    // ExpenceData(
    //   title: "Business Lunch",
    //   amount: 40.0,
    //   category: Category.Work,
    //   date: DateTime.now().subtract(Duration(days: 15)),
    // ),
    // ExpenceData(
    //   title: "Flight Tickets",
    //   amount: 200.0,
    //   category: Category.Travel,
    //   date: DateTime.now().subtract(Duration(days: 500)),
    // ),
    // ExpenceData(
    //   title: "Concert Tickets",
    //   amount: 60.0,
    //   category: Category.Lesiure,
    //   date: DateTime.now().subtract(Duration(days: 25)),
    // ),
    // ExpenceData(
    //   title: "Dinner",
    //   amount: 30.0,
    //   category: Category.Food,
    //   date: DateTime.now().subtract(Duration(days: 300)),
    // ),
    // ExpenceData(
    //   title: "Office Supplies",
    //   amount: 50.0,
    //   category: Category.Work,
    //   date: DateTime.now().subtract(Duration(days: 100)),
    // ),
  ];

  void addExpence(ExpenceData expence) {
    setState(() {
      expenceList.add(expence);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId != null) {
      final expenses = await DatabaseService.instance.getUserExpenses(userId);
      setState(() {
        expenceList = expenses;
      });
    }
  }

  void removeExpence(ExpenceData expence) async {
    final i = expenceList.indexOf(expence);
    final getTitle = expence.title;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId != null) {
        await DatabaseService.instance.deleteExpense(expence.id);

        setState(() {
          expenceList.remove(expence);
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("\"$getTitle\" deleted"),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () async {
                try {
                  await DatabaseService.instance.addExpense(userId, expence);
                  setState(() {
                    expenceList.insert(i, expence);
                  });
                } catch (e) {
                  debugPrint('Error undoing delete: $e');
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error restoring expense')),
                  );
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error removing expense: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting expense')),
      );
    }
  }

  String currentScreen = "expences";

  void updateScreen(String screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  Widget changeScreen(String screen) {
    if (screen == 'charts') {
      return Charts(expenceList: expenceList);
    } else {
      return ExpenceList(
        expence: expenceList.reversed.toList(),
        onRemoveExpence: removeExpence,
      );
    }
  }

  Widget _checkListEmpty() {
    if (expenceList.isEmpty) {
      return Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Image.asset(
                  'lib/images/arrow.png',
                  width: 100,
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: 400,
            ),
            Text(("Nothing here, try adding an expence..."))
          ],
        ),
      );
    } else {
      return changeScreen(currentScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        shadowColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Expense Tracker",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (cnt) =>
                      BottomSheetWidget(onaddExpences: addExpence),
                );
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).cardColor,
        child: SideBar(
          onScreenChange: updateScreen,
        ),
      ),
      body: _checkListEmpty(),
    );
  }
}

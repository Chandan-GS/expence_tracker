import 'package:expence_tracker/expence_list.dart';
import 'package:expence_tracker/models/expence_data.dart';
import 'package:expence_tracker/models/side_bar.dart';
import 'package:expence_tracker/pages/bottom_sheet.dart';
import 'package:expence_tracker/pages/charts.dart';
import 'package:flutter/material.dart';

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

  void removeExpence(ExpenceData expence) {
    final i = expenceList.indexOf(expence);
    final getTitle = expence.title;
    setState(() {
      expenceList.remove(expence);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).focusColor,
        action: SnackBarAction(
            textColor: Theme.of(context).cardColor,
            label: "Undo",
            onPressed: () {
              setState(() {
                expenceList.insert(i, expence);
              });
            }),
        duration: Duration(seconds: 3),
        content: Text(
          "\"$getTitle\"  deleted",
          style: TextStyle(
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
    );
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
                  elevation: 10,
                  isDismissible: true,
                  isScrollControlled: true,
                  sheetAnimationStyle:
                      AnimationStyle(duration: Duration(milliseconds: 400)),
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

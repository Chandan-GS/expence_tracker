import 'package:expence_tracker/pages/expences.dart';
import 'package:flutter/material.dart';
import 'package:expence_tracker/models/theme_provider.dart';

void main() {
  runApp(ExpenceTracker());
}

class ExpenceTracker extends StatelessWidget {
  const ExpenceTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Expences(
        screen: "expences",
      ),
    );
  }
}

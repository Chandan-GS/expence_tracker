import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme; // Default to light theme

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData =
        (_themeData.brightness == Brightness.dark) ? lightTheme : darkTheme;
    notifyListeners();
  }
}

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.black, // Primary color
    secondary: const Color.fromARGB(255, 255, 255, 255), // Secondary color
  ),
  focusColor: const Color.fromARGB(255, 50, 50, 50),
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color.fromARGB(255, 230, 230, 230),
  cardColor: Color.fromARGB(255, 250, 250, 250),
  hintColor: const Color.fromARGB(255, 180, 180, 180),
  textTheme: TextTheme(
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: const Color.fromARGB(255, 0, 140, 255))),
  iconTheme: IconThemeData(color: Colors.black),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.white, // Primary color
    secondary: const Color.fromARGB(255, 0, 0, 0), // Secondary color
  ),
  focusColor: Color.fromARGB(255, 221, 221, 221),
  hintColor: const Color.fromARGB(255, 113, 113, 113),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color.fromARGB(255, 20, 20, 20),
  cardColor: const Color.fromARGB(255, 44, 44, 44),
  textTheme: TextTheme(
    titleMedium: TextStyle(color: const Color.fromARGB(255, 221, 221, 221)),
    titleSmall: TextStyle(color: const Color.fromARGB(255, 79, 176, 255)),
  ),
  iconTheme: IconThemeData(color: const Color.fromARGB(255, 221, 221, 221)),
);

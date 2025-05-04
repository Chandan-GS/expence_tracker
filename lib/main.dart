import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expence_tracker/pages/expences.dart';
import 'package:expence_tracker/pages/start_page.dart';
import 'package:expence_tracker/models/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'database_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb) {
      // Web-specific database initialization
      var databaseFactory = databaseFactoryFfiWeb;
      final database = await databaseFactory.openDatabase(
        'expense_tracker.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await DatabaseService.instance.createTables(db, version);
          },
          onConfigure: (db) async {
            await db.execute('PRAGMA foreign_keys = ON');
          },
        ),
      );
      DatabaseService.instance.setDatabase(database);
    } else {
      // Mobile-specific database initialization
      final appDocDir = await getApplicationDocumentsDirectory();
      final databasePath = join(appDocDir.path, 'expense_tracker.db');

      final database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) async {
          await DatabaseService.instance.createTables(db, version);
        },
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
      DatabaseService.instance.setDatabase(database);
    }

    runApp(const ExpenceTracker());
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}

class ExpenceTracker extends StatefulWidget {
  const ExpenceTracker({super.key});

  @override
  State<ExpenceTracker> createState() => _ExpenceTrackerState();
}

class _ExpenceTrackerState extends State<ExpenceTracker> {
  Widget _initialScreen = const StartPage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (mounted) {
        setState(() {
          _initialScreen = userId != null
              ? const Expences(screen: "expences")
              : const StartPage();
        });
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      if (mounted) {
        setState(() {
          _initialScreen = const StartPage();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: _initialScreen,
    );
  }
}

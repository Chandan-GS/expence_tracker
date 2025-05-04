import 'package:expence_tracker/database_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.onScreenChange});

  final Function(String) onScreenChange;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getString('user_id');
              if (userId != null) {
                await DatabaseService.instance.deleteUserAccount(userId);
                await prefs.clear();
                if (ctx.mounted) {
                  Navigator.of(ctx).pushReplacementNamed('/login');
                }
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 25),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.bar_chart),
          title: Text('Charts'),
          onTap: () {
            widget.onScreenChange('charts');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.currency_rupee),
          title: Text('Expenses'),
          onTap: () {
            widget.onScreenChange('expenselist');
            Navigator.pop(context);
          },
        ),
        Spacer(), // Pushes the following items to the bottom
        Divider(), // Adds a line separator
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () => _logout(context),
        ),
        ListTile(
          leading: Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
          title: Text(
            'Delete Account',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => _deleteAccount(context),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

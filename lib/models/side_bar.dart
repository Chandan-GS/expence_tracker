import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.onScreenChange});

  final Function(String) onScreenChange;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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
        SizedBox(
          height: 20,
        ),
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
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

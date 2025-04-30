import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
  });

  final double fill;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: fill,
      widthFactor: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          color: Theme.of(context).focusColor,
        ),
      ),
    );
  }
}

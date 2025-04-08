import 'package:flutter/material.dart';

class TripSubCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  const TripSubCard({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: color ?? Theme.of(context).colorScheme.surface,
      ),
      padding: EdgeInsets.all(8.0),
      child: child,
    );
  }
}

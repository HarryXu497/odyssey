import 'package:flutter/material.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Hello"));
  }
}

class TripsScreenAppBar extends StatelessWidget {
  const TripsScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("YOUR TRIPS", style: Theme.of(context).textTheme.headlineLarge);
  }
}

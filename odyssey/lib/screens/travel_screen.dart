import 'package:flutter/material.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TravelScreenAppBar extends StatelessWidget {
  const TravelScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("TRAVEL", style: Theme.of(context).textTheme.headlineLarge);
  }
}
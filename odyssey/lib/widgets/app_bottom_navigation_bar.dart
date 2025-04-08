import 'package:flutter/material.dart';
import 'package:odyssey/routes/route_names.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  const AppBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  State<AppBottomNavigationBar> createState() =>
      _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState
    extends State<AppBottomNavigationBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    setState(() {
      _currentIndex = widget.currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor:
          Theme.of(context).colorScheme.primary,
      selectedItemColor:
          Theme.of(context).colorScheme.secondary,
      unselectedItemColor:
          Theme.of(context).colorScheme.onPrimary,
      currentIndex: _currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.card_travel),
          label: "TRIPS",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airline_stops_outlined),
          label: "TRAVEL",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "PROFILE",
        ),
      ],
      onTap: (value) {
        if (value == 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.tripsScreen,
            (route) => false,
          );
        }

        if (value == 1) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.travelScreen,
            (route) => false,
          );
        }

        if (value == 2) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.profileScreen,
            (route) => false,
          );
        }

        setState(() {
          _currentIndex = value;
        });
      },
    );
  }
}

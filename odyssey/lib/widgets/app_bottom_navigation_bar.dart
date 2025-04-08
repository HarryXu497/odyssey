import 'package:flutter/material.dart';
import 'package:odyssey/routes/route_names.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: "TRIPS"),
        BottomNavigationBarItem(icon: Icon(Icons.airline_stops_outlined), label: "TRAVEL"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
      ],
      onTap: (value) {
        if (value == 0) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.tripsScreen, (route) => false);
        }

        if (value == 1) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.travelScreen, (route) => false);
        }
 
        if (value == 2) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.profileScreen, (route) => false);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:odyssey/routes/route_names.dart';
import 'package:odyssey/screens/profile_screen.dart';
import 'package:odyssey/screens/travel_screen.dart';
import 'package:odyssey/screens/trips_screen.dart';

class HomeScreen extends StatefulWidget {
  final int startScreenIndex;
  const HomeScreen({super.key, this.startScreenIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<Widget> _appBars = [
    TripsScreenAppBar(),
    TravelScreenAppBar(),
    ProfileScreenAppBar(),
  ];

  static const List<Widget> _screens = [
    TripsScreen(),
    TravelScreen(),
    ProfileScreen(),
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedIndex = widget.startScreenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _appBars.elementAt(_selectedIndex),
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).colorScheme.onPrimary,
      ),
      body: _screens.elementAt(_selectedIndex),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          await Navigator.of(
            context,
          ).pushNamed(RouteNames.newTripScreen);
        },
        backgroundColor:
            Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          size: 32.0,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        selectedItemColor:
            Theme.of(context).colorScheme.secondary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onPrimary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: "TRIPS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airline_stops),
            label: "TRAVEL",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "PROFILE",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}

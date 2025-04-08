import 'package:flutter/material.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/pocketbase.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
    List<TripContainerItemModel>? _trips;

  Future _getTrips() async {
    final rawData = await pb
      .collection("trips")
      .getFullList(expand: "containers,containers.items");

    final trips = rawData.map(TripContainerItemModel.fromExpandedRecord).toList();

    setState(() {
      _trips = trips;
    });

  }

  void initTrips() async {
    await _getTrips();

    await pb
        .collection("trips")
        .subscribe("*", (_) => _getTrips());

    await pb
        .collection("containers")
        .subscribe("*", (_) => _getTrips());

    await pb
        .collection("items")
        .subscribe("*", (_) => _getTrips());
  }

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
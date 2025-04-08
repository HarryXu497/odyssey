
import 'package:flutter/material.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/pocketbase.dart';
import 'package:odyssey/widgets/trips/trip_card.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  List<TripContainerItemModel>? _trips;

  void initTrips() async {
    final rawData = await pb
        .collection("trips")
        .getFullList(expand: "containers,containers.items");

    final trips = rawData.map(TripContainerItemModel.fromExpandedRecord);

    setState(() {
      _trips = trips.toList();
    });
  }

  @override
  void initState() {
    super.initState();

    initTrips();
  }

  @override
  Widget build(BuildContext context) {
    return _trips == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
          padding: EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            return TripCard(tripContainerItemModel: _trips![index]);
          },
          separatorBuilder:
              (_, _) => SizedBox(height: 12.0),
          itemCount: _trips!.length,
        );
  }
}

class TripsScreenAppBar extends StatelessWidget {
  const TripsScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "YOUR TRIPS",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

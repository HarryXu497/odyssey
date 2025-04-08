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

  Future _getTrips() async {
    final rawData = await pb
        .collection("trips")
        .getFullList(expand: "containers,containers.items");

    final trips =
        rawData
            .map(TripContainerItemModel.fromExpandedRecord)
            .toList();

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

  void disposeListeners() async {
    await pb.collection("trips").unsubscribe("*");
    await pb.collection("containers").unsubscribe("*");
    await pb.collection("items").unsubscribe("*");
  }

  @override
  void dispose() {
    super.dispose();

    disposeListeners();
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
            final trip = _trips![index];
            return Dismissible(
              key: Key(trip.tripModel.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                await pb
                    .collection("trips")
                    .delete(trip.tripModel.id);
              },
              child: TripCard(
                tripContainerItemModel: trip,
              ),
            );
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

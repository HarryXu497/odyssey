import 'package:flutter/material.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/pocketbase.dart';

import 'package:odyssey/widgets/containers/trip_card.dart';

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

    final trips =
        rawData
            .map(TripContainerItemModel.fromExpandedRecord)
            .toList();

    setState(() {
      _trips = trips;
    });
  }

  @override
  void initState() {
    super.initState();
    
    initTrips();
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

  // build

  //e
  @override
  Widget build(BuildContext context) {
    if (_trips == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 8.0),
            ListView.separated(
              shrinkWrap: true,
              itemCount: _trips!.length,
              separatorBuilder:
                  (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _trips![index];
                return Dismissible(
                  key: Key(item.tripModel.name),
                  child: TripCard(
                    tripContainerItemModel: item,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}

class TravelScreenAppBar extends StatelessWidget {
  const TravelScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "TRAVEL",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

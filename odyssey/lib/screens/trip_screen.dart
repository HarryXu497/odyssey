import 'package:flutter/material.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/pocketbase.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';
import 'package:odyssey/widgets/containers/container_card.dart';

class TripScreen extends StatefulWidget {
  final String tripId;

  const TripScreen({super.key, required this.tripId});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  TripContainerItemModel? _tripContainerItemModel;

  Future _getTripData() async {
    final rawData = await pb
        .collection("trips")
        .getOne(
          widget.tripId,
          expand: "containers,containers.items",
        );

    setState(() {
      _tripContainerItemModel =
          TripContainerItemModel.fromExpandedRecord(
            rawData,
          );
    });
  }

  void initModel() async {
    await _getTripData();

    await pb
        .collection("trips")
        .subscribe("*", (_) => _getTripData());

    await pb
        .collection("containers")
        .subscribe("*", (_) => _getTripData());

    await pb
        .collection("items")
        .subscribe("*", (_) => _getTripData());
  }

  @override
  void initState() {
    super.initState();

    initModel();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithNavigation(
      appBar: AppBar(
        title: Text(
          _tripContainerItemModel == null
              ? ""
              : _tripContainerItemModel!.tripModel.name
                  .toUpperCase(),
          style: Theme.of(context).textTheme.headlineLarge,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).colorScheme.onPrimary,
      ),
      body:
          _tripContainerItemModel == null
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : TripScreenBody(
                tripContainerItemModel:
                    _tripContainerItemModel!,
              ),
    );
  }
}

class TripScreenBody extends StatelessWidget {
  final TripContainerItemModel tripContainerItemModel;
  const TripScreenBody({
    super.key,
    required this.tripContainerItemModel,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              Text(
                "containers",
                style:
                    Theme.of(
                      context,
                    ).textTheme.displaySmall,
              ),
              TextButton(
                onPressed: () {
                  // TODO: new container
                },
                child: Text(
                  "add new",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.normal,
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item =
                  tripContainerItemModel
                      .containerItemModels[index];
              return Dismissible(
                key: Key(item.containerModel.id),
                child: ContainerCard(
                  containerItemModel: item,
                ),
              );
            },
            separatorBuilder:
                (_, _) => SizedBox(height: 12.0),
            itemCount:
                tripContainerItemModel
                    .containerItemModels
                    .length,
          ),
        ],
      ),
    );
  }
}

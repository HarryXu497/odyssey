import 'package:flutter/material.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/models/weather/weather_model.dart';
import 'package:odyssey/pocketbase.dart';
import 'package:odyssey/screens/create_container_screen.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';
import 'package:odyssey/widgets/containers/container_card.dart';
import 'package:odyssey/widgets/weather/weather_card.dart';
import 'package:pocketbase/pocketbase.dart';

class TripScreen extends StatefulWidget {
  final String tripId;

  const TripScreen({super.key, required this.tripId});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  TripContainerItemModel? _tripContainerItemModel;
  WeatherData? _startWeatherData;
  WeatherData? _endWeatherData;

  Future<RecordModel> _getRawTripData() async {
    return pb
        .collection("trips")
        .getOne(
          widget.tripId,
          expand: "containers,containers.items",
        );
  }

  Future _getTripData() async {
    final rawData = await _getRawTripData();

    setState(() {
      _tripContainerItemModel =
          TripContainerItemModel.fromExpandedRecord(
            rawData,
          );
    });
  }

  void initModel() async {
    final tripContainerItemModel =
        TripContainerItemModel.fromExpandedRecord(
          await _getRawTripData(),
        );

    final startWeatherData =
        await WeatherData.fetchWeatherData(
          tripContainerItemModel
              .tripModel
              .startLatLng
              .latitude,
          tripContainerItemModel
              .tripModel
              .startLatLng
              .longitude,
        );

    final endWeatherData =
        await WeatherData.fetchWeatherData(
          tripContainerItemModel
              .tripModel
              .endLatLng
              .latitude,
          tripContainerItemModel
              .tripModel
              .endLatLng
              .longitude,
        );

    setState(() {
      _tripContainerItemModel = tripContainerItemModel;
      _startWeatherData = startWeatherData;
      _endWeatherData = endWeatherData;
    });

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
          (_tripContainerItemModel == null ||
                  _startWeatherData == null ||
                  _endWeatherData == null)
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : TripScreenBody(
                tripContainerItemModel:
                    _tripContainerItemModel!,
                startWeatherData: _startWeatherData!,
                endWeatherData: _endWeatherData!,
              ),
    );
  }
}

class TripScreenBody extends StatelessWidget {
  final WeatherData startWeatherData;
  final WeatherData endWeatherData;
  final TripContainerItemModel tripContainerItemModel;

  const TripScreenBody({
    super.key,
    required this.tripContainerItemModel,
    required this.startWeatherData,
    required this.endWeatherData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  onPressed: () async {
                    final String? result =
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    CreateContainerScreen(),
                          ),
                        );

                    if (result == null) {
                      return;
                    }

                    final container = await pb
                        .collection("containers")
                        .create(
                          body: {
                            "name": result,
                            "containers": [],
                          },
                        );

                    await pb
                        .collection("trips")
                        .update(
                          tripContainerItemModel
                              .tripModel
                              .id,
                          body: {
                            "containers+": [container.id],
                          },
                        );
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
            tripContainerItemModel
                    .containerItemModels
                    .isEmpty
                ? Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [const NoTripCard()],
                )
                : ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item =
                        tripContainerItemModel
                            .containerItemModels[index];
                    return Dismissible(
                      direction:
                          DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await pb
                            .collection("containers")
                            .delete(item.containerModel.id);
                      },
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
            SizedBox(height: 16.0),
            Text(
              "weather",
              style:
                  Theme.of(context).textTheme.displaySmall,
            ),
            WeatherCard(
              location:
                  tripContainerItemModel
                      .tripModel
                      .startName,
              weatherData: startWeatherData,
            ),
            SizedBox(height: 12.0),
            WeatherCard(
              location:
                  tripContainerItemModel.tripModel.endName,
              weatherData: endWeatherData,
            ),
          ],
        ),
      ),
    );
  }
}

class NoTripCard extends StatelessWidget {
  const NoTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.onPrimary,
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            "no containers yet",
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(
              color:
                  Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:odyssey/models/containers/container_item_model.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/pocketbase.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';
import 'package:pocketbase/pocketbase.dart';

class ContainerListScreen extends StatefulWidget {
  final String tripId;

  const ContainerListScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<ContainerListScreen> createState() =>
      _ContainerListScreenState();
}

class _ContainerListScreenState extends State<ContainerListScreen> {
  TripContainerItemModel? _tripContainerItemModel;

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

    setState(() {
      _tripContainerItemModel = tripContainerItemModel;
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

  void disposeListener() async {
    await pb.collection("trips").unsubscribe('*');
    await pb.collection("containers").unsubscribe('*');
    await pb.collection("items").unsubscribe('*');
  }

  @override
  void dispose() {
    super.dispose();

    disposeListener();
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
              : ContainerListScreenBody(
                tripContainerItemModel: _tripContainerItemModel!,
              ),
    );
  }
}

class ContainerListScreenBody extends StatefulWidget {
  final TripContainerItemModel tripContainerItemModel;

  const ContainerListScreenBody({
    super.key,
    required this.tripContainerItemModel,
  });

  @override
  State<ContainerListScreenBody> createState() =>
      ContainerListScreenBodyState();
}

class ContainerListScreenBodyState
    extends State<ContainerListScreenBody> {

  void Function(bool?) _onContainerChecked(ContainerItemModel containerItemModel) {
    return (newValue) async {
      await pb
          .collection("containers")
          .update(
            containerItemModel.containerModel.id,
            body: {"checked": newValue ?? false},
        );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder:
                (_, _) => HorizontalLineSeparator(),
            itemBuilder: (context, index) {
              final container =
                  widget
                      .tripContainerItemModel
                      .containerItemModels[index];

              return CheckboxListTile(
                value: container.containerModel.checked,
                onChanged: _onContainerChecked(container),
                title: Text(
                  container.containerModel.name.toLowerCase(),
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleMedium,
                ),
              );
            },
            itemCount:
                widget.tripContainerItemModel.containerItemModels.length,
          ),
        ],
      ),
    );
  }
}

class ListTileButton extends StatelessWidget {
  final void Function() onTap;
  final String text;

  const ListTileButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

class HorizontalLineSeparator extends StatelessWidget {
  const HorizontalLineSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}

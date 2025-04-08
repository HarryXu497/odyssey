import 'package:flutter/material.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/routes/route_names.dart';

class TripCard extends StatelessWidget {
  final TripContainerItemModel tripContainerItemModel;

  // Max number of list tiles to show in a preview card
  static const kPreviewCount = 4;

  const TripCard({
    super.key,
    required this.tripContainerItemModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.onPrimary,
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 4.0,
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).pushNamed(
            RouteNames.containerListScreen,
            arguments: tripContainerItemModel.tripModel.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tripContainerItemModel.tripModel.name,
                style:
                    Theme.of(context).textTheme.titleSmall,
              ),
              Row(
                children: [
                  Text(
                    tripContainerItemModel
                        .tripModel
                        .startName
                        .toLowerCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    tripContainerItemModel.tripModel.endName
                        .toLowerCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/routes/route_names.dart';
import 'package:odyssey/widgets/trips/container_preview_card.dart';
import 'package:odyssey/widgets/trips/trip_sub_card.dart';

class TripCard extends StatelessWidget {
  final TripContainerItemModel tripContainerItemModel;
  const TripCard({
    super.key,
    required this.tripContainerItemModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).pushNamed(
          RouteNames.tripScreen,
          arguments: tripContainerItemModel.tripModel.id,
        );
      },
      child: Card.filled(
        color: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tripContainerItemModel.tripModel.name
                    .toLowerCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(height: 0.7),
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
              SizedBox(height: 8.0),
              tripContainerItemModel
                      .containerItemModels
                      .isEmpty
                  ? TripSubCard(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Center(
                      child: Text(
                        "no containers yet",
                        style:
                            Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                  )
                  : GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    shrinkWrap: true,
                    childAspectRatio: (1 / .3),
                    // crossAxisAlignment:
                    //     WrapCrossAlignment.start,
                    children: [
                      for (final containerItemModel
                          in tripContainerItemModel
                              .containerItemModels)
                        ContainerPreviewCard(
                          containerItemModel:
                              containerItemModel,
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

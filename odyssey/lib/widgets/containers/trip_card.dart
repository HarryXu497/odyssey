import 'dart:math';

import 'package:flutter/material.dart';
import 'package:odyssey/models/containers/container_item_model.dart';
import 'package:odyssey/models/trips/trip_container_item_model.dart';
import 'package:odyssey/routes/route_names.dart';
import 'package:odyssey/widgets/containers/container_preview.dart';

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
              /*
              ContainerPreview(
                items: containerItemModel.itemModels
                    .sublist(
                      0,
                      min(
                        kPreviewCount,
                        containerItemModel
                            .itemModels
                            .length,
                      ),
                    ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}

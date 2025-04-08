import 'dart:math';

import 'package:flutter/material.dart';
import 'package:odyssey/models/containers/container_item_model.dart';
import 'package:odyssey/routes/route_names.dart';
import 'package:odyssey/widgets/containers/container_preview.dart';

class ContainerCard extends StatelessWidget {
  final ContainerItemModel containerItemModel;
  final String weather;
  final String location;

  // Max number of list tiles to show in a preview card
  static const kPreviewCount = 4;

  const ContainerCard({
    super.key,
    required this.weather,
    required this.location,
    required this.containerItemModel,
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
            RouteNames.containerScreen,
            arguments: [
              containerItemModel.containerModel.id,
              weather,
              location,
            ],
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                containerItemModel.containerModel.name,
                style:
                    Theme.of(context).textTheme.titleSmall,
              ),
              if (containerItemModel.itemModels.isNotEmpty)
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
            ],
          ),
        ),
      ),
    );
  }
}

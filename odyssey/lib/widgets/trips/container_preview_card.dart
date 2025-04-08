import 'package:flutter/material.dart';
import 'package:odyssey/models/containers/container_item_model.dart';
import 'package:odyssey/widgets/sub_card.dart';

class ContainerPreviewCard extends StatelessWidget {
  final ContainerItemModel containerItemModel;
  final int previewCount;

  const ContainerPreviewCard({
    super.key,
    required this.containerItemModel,
    this.previewCount = 4,
  }) : assert(previewCount > 0);

  @override
  Widget build(BuildContext context) {
    return SubCard(
      child: Center(
        child: Text(
          containerItemModel.containerModel.name,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}

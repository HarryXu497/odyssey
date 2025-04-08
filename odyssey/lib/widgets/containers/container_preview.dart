import 'package:flutter/material.dart';
import 'package:odyssey/models/items/item_model.dart';

class ContainerPreview extends StatelessWidget {
  final List<ItemModel> items;
  const ContainerPreview({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          horizontalTitleGap: 4.0,
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.all(0),
          leading: Icon(
            item.checked
                ? Icons.circle
                : Icons.circle_outlined,
            size: 20.0,
          ),
          dense: true,
          title: Text(
            item.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      },
      itemCount: items.length,
    );
  }
}

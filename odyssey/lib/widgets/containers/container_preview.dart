import 'package:flutter/material.dart';
import 'package:odyssey/models/items/item_model.dart';
import 'package:odyssey/widgets/sub_card.dart';

class ContainerPreview extends StatelessWidget {
  final List<ItemModel> items;
  const ContainerPreview({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SubCard(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = items[index];
      
          return CheckboxListTile(
            contentPadding: EdgeInsets.all(0),
            value: item.checked,
            onChanged: null,
            dense: true,
            title: Text(
              item.name.toLowerCase(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}

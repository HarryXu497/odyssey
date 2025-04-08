import 'package:odyssey/models/containers/container_model.dart';
import 'package:odyssey/models/items/item_model.dart';
import 'package:pocketbase/pocketbase.dart';

class ContainerItemModel {
  final ContainerModel containerModel;
  final List<ItemModel> itemModels;

  const ContainerItemModel({
    required this.containerModel,
    required this.itemModels,
  });

  factory ContainerItemModel.fromExpandedRecord(RecordModel container) {
    return ContainerItemModel(
      containerModel: ContainerModel(
        id: container.id,
        name: container.getStringValue("name"),
        checked: container.getBoolValue("checked")
      ),
      itemModels:
          (container
              .get("expand")["items"] ?? [])
              .map<ItemModel>(
                (item) => ItemModel(
                    id: item["id"] as String,
                    name: item["name"] as String,
                    checked: item["checked"] as bool,
                  ),
              ).toList(),
    );
  }
}

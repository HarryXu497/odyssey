import 'package:odyssey/models/containers/container_model.dart';
import 'package:odyssey/models/items/item_model.dart';

class ContainerItemModel {
  final ContainerModel containerModel;
  final List<ItemModel> itemModels;

  const ContainerItemModel({
    required this.containerModel,
    required this.itemModels,
  });
}

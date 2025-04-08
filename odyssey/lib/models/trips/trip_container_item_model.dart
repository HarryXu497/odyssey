import 'package:map_location_picker/map_location_picker.dart';
import 'package:odyssey/models/containers/container_item_model.dart';
import 'package:odyssey/models/containers/container_model.dart';
import 'package:odyssey/models/items/item_model.dart';
import 'package:odyssey/models/trips/trip_model.dart';
import 'package:pocketbase/pocketbase.dart';

class TripContainerItemModel {
  final TripModel tripModel;
  final List<ContainerItemModel> containerItemModels;

  const TripContainerItemModel({
    required this.tripModel,
    required this.containerItemModels,
  });

  factory TripContainerItemModel.fromExpandedRecord(
    RecordModel trip,
  ) {
    return TripContainerItemModel(
      tripModel: TripModel(
        id: trip.id,
        name: trip.getStringValue("name"),
        startLatLng: LatLng(
          trip.getDoubleValue("start_lat"),
          trip.getDoubleValue("start_lng"),
        ),
        endLatLng: LatLng(
          trip.getDoubleValue("end_lat"),
          trip.getDoubleValue("end_lng"),
        ),
        startName: trip.getStringValue("start"),
        endName: trip.getStringValue("end"),
      ),
      containerItemModels:
          (trip
              .get("expand")["containers"] ?? [])
              .map<ContainerItemModel>(
                (container) => ContainerItemModel(
                  containerModel: ContainerModel(
                    id: container["id"] as String,
                    name: container["name"] as String,
                    checked: container["checked"] as bool,
                  ),
                  itemModels:
                      (container["expand"]["items"] ?? [])
                          .map<ItemModel>(
                            (item) => ItemModel(
                              id: item["id"],
                              name: item["name"] as String,
                              checked:
                                  item["checked"] as bool,
                            ),
                          )
                          .toList(),
                ),
              )
              .toList(),
    );
  }
}

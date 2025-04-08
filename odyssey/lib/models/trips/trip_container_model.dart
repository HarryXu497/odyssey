import 'package:odyssey/models/containers/container_model.dart';
import 'package:odyssey/models/trips/trip_model.dart';

class TripContainerModel {
  final TripModel tripModel;
  final List<ContainerModel> containerModels;

  const TripContainerModel({required this.tripModel, required this.containerModels});
}

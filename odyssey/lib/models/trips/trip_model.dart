import 'package:map_location_picker/map_location_picker.dart';

class TripModel {
  final String id;
  final String name;
  final LatLng startLatLng;
  final LatLng endLatLng;
  final String startName;
  final String endName;

  const TripModel({
    required this.id,
    required this.name,
    required this.startLatLng,
    required this.endLatLng,
    required this.startName,
    required this.endName,
  });
}

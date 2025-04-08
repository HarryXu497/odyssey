import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:odyssey/models/questions/location_question_model.dart';
import 'package:odyssey/models/questions/text_question_model.dart';
import 'package:odyssey/pocketbase.dart';
import 'package:odyssey/screens/container_list_screen.dart';
import 'package:odyssey/screens/container_screen.dart';
import 'package:odyssey/screens/home_screen.dart';
import 'package:odyssey/screens/questions_screen.dart';
import 'package:odyssey/screens/trip_screen.dart';

String computeLocality(GeocodingResult res) {
  // Iterates through the address components until it finds
  // the component with a type of 'locality'
  // If it can't find a locality, it returns the first component of the address
  AddressComponent locality = res.addressComponents
      .firstWhere(
        (l) => l.types.any((g) => g == "locality"),
        orElse: () => res.addressComponents[0],
      );

  return locality.shortName.toLowerCase();
}

class RouteNames {
  static const String homeScreen = "/home";
  static const String tripsScreen = "/home/trips";
  static const String travelScreen = "/home/travel";
  static const String profileScreen = "/home/profile";
  static const String newTripScreen = "/home/trips/new";
  static const String locationPickerScreen =
      "/pick-location";
  static const String tripScreen = "/home/trips/{trip_id}";
  // Since container ID's are unique we can get away with only 1 route param
  static const String containerScreen =
      "/home/trip/{trip_id}/container/{container_id}";

  static const String containerListScreen =
      "/home/travel/{trip_id}";

  static Route<dynamic> generateRoutes(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case RouteNames.homeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case RouteNames.tripsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => const HomeScreen(startScreenIndex: 0),
        );

      case RouteNames.tripScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final id = settings.arguments as String;

            return TripScreen(tripId: id);
          },
        );

      case RouteNames.containerScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final data = settings.arguments as List<String>;
            final id = data[0];
            final weatherData = data[1];
            final locationData = data[1];

            return ContainerScreen(containerId: id, weatherData: weatherData, locationData: locationData);
          },
        );

      case RouteNames.travelScreen:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => const HomeScreen(startScreenIndex: 1),
        );

      case RouteNames.containerListScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final id = settings.arguments as String;

            return ContainerListScreen(tripId: id);
          },
        );

      case RouteNames.profileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => const HomeScreen(startScreenIndex: 2),
        );

      case RouteNames.newTripScreen:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => QuestionsScreen(
                startingIndex: 0,
                questions: [
                  TextQuestionModel(
                    question:
                        "First, give your trip a name",
                    placeholder: "your next trip",
                  ),
                  LocationQuestionModel(
                    question: "where are you starting?",
                  ),
                  LocationQuestionModel(
                    question: "where are you ending?",
                  ),
                ],
                onDone: (values) async {
                  final name = values[0] as String;
                  final start =
                      values[1] as GeocodingResult;
                  final end = values[2] as GeocodingResult;

                  await pb
                      .collection("trips")
                      .create(
                        body: {
                          "name": name,
                          "start": computeLocality(start),
                          "start_lat":
                              start.geometry.location.lat,
                          "start_lng":
                              start.geometry.location.lng,
                          "end": computeLocality(end),
                          "end_lat":
                              end.geometry.location.lat,
                          "end_lng":
                              end.geometry.location.lng,
                        },
                      );

                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(
                      RouteNames.homeScreen,
                      (route) => false,
                    );
                  }
                },
              ),
        );

      default:
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                backgroundColor:
                    Theme.of(context).colorScheme.surface,
                body: Center(
                  child: Text(
                    'No route found for ${settings.name}',
                  ),
                ),
              ),
        );
    }
  }
}

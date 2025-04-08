import 'package:flutter/material.dart';
import 'package:odyssey/models/questions/text_question_model.dart';
import 'package:odyssey/screens/home_screen.dart';
import 'package:odyssey/screens/questions_screen.dart';

class RouteNames {
  static const String homeScreen = "/home";
  static const String tripsScreen = "/home/trips";
  static const String profileScreen = "/home/profile";
  static const String newTripScreen = "/home/trips/new";

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

      case RouteNames.profileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => const HomeScreen(startScreenIndex: 1),
        );

      case RouteNames.newTripScreen:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => QuestionsScreen(
                questions: [
                  TextQuestionModel(
                    question:
                        "First, give your trip a name",
                    placeholder: "your next trip",
                  ),
                ],
                onDone: (values) {
                  final name = values[0] as String;
                  print(name);
                },
              ),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
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

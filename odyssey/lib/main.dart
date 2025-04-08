import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odyssey/routes/route_names.dart';


final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 34, 56, 67),
  primary: const Color.fromARGB(255, 34, 56, 67),
  primaryContainer: const Color.fromARGB(255, 52, 85, 101),
  onPrimary: const Color.fromARGB(255, 249, 250, 251),
  surface: const Color.fromARGB(255, 239, 241, 243),
  onSurface: const Color.fromARGB(255, 34, 56, 67),
  secondary: const Color.fromARGB(255, 98, 144, 195),
  shadow: const Color.fromARGB(64, 34, 56, 67),
  brightness: Brightness.light,
);

void main() {    
  runApp(const OdysseyApp());
}

class OdysseyApp extends StatelessWidget {
  const OdysseyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odyssey',
      initialRoute: RouteNames.homeScreen,
      onGenerateRoute: RouteNames.generateRoutes,
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route found for ${settings.name}'),
            ),
          ),
        );
      },
      theme: ThemeData().copyWith(
        colorScheme: colorScheme,
        textTheme: GoogleFonts.josefinSansTextTheme().copyWith(
          headlineLarge: GoogleFonts.josefinSans().copyWith(
            fontSize: 32.0,
          ),
          headlineMedium: GoogleFonts.josefinSans().copyWith(
            fontSize: 30.0,
          ),
          headlineSmall: GoogleFonts.josefinSans().copyWith(
            fontSize: 28.0,
          ),
          titleLarge: GoogleFonts.josefinSans().copyWith(
            fontSize: 24.0,
          ),
          titleMedium: GoogleFonts.josefinSans().copyWith(
            fontSize: 16.0,
          ),
          bodyLarge: GoogleFonts.josefinSans().copyWith(
            fontSize: 18.0,
          ),
          bodyMedium: GoogleFonts.josefinSans().copyWith(
            fontSize: 16.0,
          ),
          bodySmall: GoogleFonts.josefinSans().copyWith(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
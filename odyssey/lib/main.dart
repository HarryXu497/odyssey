import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odyssey/routes/route_names.dart';


final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 34, 56, 67),
  primary: const Color.fromARGB(255, 34, 56, 67),
  primaryContainer: const Color.fromARGB(255, 52, 85, 101),
  onPrimary: const Color.fromARGB(255, 249, 250, 251),
  surface: const Color.fromARGB(255, 230, 232, 234),
  onSurface: const Color.fromARGB(255, 34, 56, 67),
  secondary: const Color.fromARGB(255, 98, 144, 195),
  shadow: const Color.fromARGB(64, 34, 56, 67),
  brightness: Brightness.light,
);

Future main() async {    
  await dotenv.load(fileName: ".env");
  
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
            backgroundColor: Theme.of(context).colorScheme.surface,
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
            color: colorScheme.onPrimary,
          ),
          headlineMedium: GoogleFonts.josefinSans().copyWith(
            fontSize: 30.0,
            color: colorScheme.onPrimary,
          ),
          headlineSmall: GoogleFonts.josefinSans().copyWith(
            fontSize: 28.0,
            color: colorScheme.onPrimary,
          ),
          titleLarge: GoogleFonts.josefinSans().copyWith(
            fontSize: 28.0,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.josefinSans().copyWith(
            fontSize: 26.0,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: GoogleFonts.josefinSans().copyWith(
            fontSize: 24.0,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,  
          ),
          bodyLarge: GoogleFonts.josefinSans().copyWith(
            fontSize: 22.0,
            color: colorScheme.primary,
          ),
          bodyMedium: GoogleFonts.josefinSans().copyWith(
            fontSize: 20.0,
            color: colorScheme.primary,
          ),
          bodySmall: GoogleFonts.josefinSans().copyWith(
            fontSize: 18.0,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
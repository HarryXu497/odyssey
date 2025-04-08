import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';

class LocationPickerScreen extends StatelessWidget {
  final Position position;

  const LocationPickerScreen({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenWithNavigation(
      appBar: AppBar(
        title: Text(
          "PICK A PLACE",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).colorScheme.onPrimary,
      ),
      body: MapLocationPicker(
        apiKey:
            Platform.isIOS
                ? dotenv.env['GOOGLE_MAPS_API_KEY_IOS']!
                : dotenv
                    .env['GOOGLE_MAPS_API_KEY_ANDROID']!,
        currentLatLng: LatLng(
          position.latitude,
          position.longitude,
        ),
      ),
    );
  }
}

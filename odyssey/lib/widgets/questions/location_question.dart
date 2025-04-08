import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:odyssey/models/questions/location_question_model.dart';
import 'package:odyssey/widgets/questions/next_button.dart';

class LocationQuestion extends StatefulWidget {
  final LocationQuestionModel model;
  final void Function(GeocodingResult) onSubmit;

  const LocationQuestion({
    super.key,
    required this.model,
    required this.onSubmit,
  });

  @override
  State<LocationQuestion> createState() =>
      _LocationQuestionState();
}

class _LocationQuestionState
    extends State<LocationQuestion> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(
        'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
          'Location permissions are denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Position? _position;
  GeocodingResult? selectedPosition;

  void initPosition() async {
    Position? pos;

    try {
      pos = await _determinePosition();
    } on Exception {
      pos = null;
    }

    setState(() {
      _position = pos;
    });
  }

  @override
  void initState() {
    super.initState();

    initPosition();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.model.question,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 12.0),
          SizedBox(
            width: 360,
            height: 360,
            child:
                _position != null
                    ? MapLocationPicker(
                      padding: EdgeInsets.all(10),
                      apiKey:
                          Platform.isIOS
                              ? dotenv
                                  .env['GOOGLE_MAPS_API_KEY_IOS']!
                              : dotenv
                                  .env['GOOGLE_MAPS_API_KEY_ANDROID']!,
                      currentLatLng: LatLng(
                        _position!.latitude,
                        _position!.longitude,
                      ),
                      topCardColor:
                          Theme.of(
                            context,
                          ).colorScheme.primary,
                      bottomCardColor:
                          Theme.of(
                            context,
                          ).colorScheme.primary,
                      zoomGesturesEnabled: true,
                      hideSearchBar: true,
                      hideMoreOptions: true,
                      hideBottomCard: true,
                      hideBackButton: true,
                      hideLocationButton: true,
                      hideMapTypeButton: true,
                      onDecodeAddress: (result) {
                        selectedPosition = result;
                      },
                    )
                    : null,
          ),
          SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: NextButton(
              onPressed: () {
                if (selectedPosition != null) {
                  widget.onSubmit(selectedPosition!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

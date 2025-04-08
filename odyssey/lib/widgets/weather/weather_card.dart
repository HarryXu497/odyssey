import 'package:flutter/material.dart';
import 'package:odyssey/models/weather/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final String location;
  final WeatherData weatherData;
  const WeatherCard({
    super.key,
    required this.location,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    final (description, iconData) =
        weatherData.generateWeatherDescription();
    return Card.filled(
      color: Theme.of(context).colorScheme.onPrimary,
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 4.0,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  location.toLowerCase(),
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleSmall,
                ),
                SizedBox(height: 4.0),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

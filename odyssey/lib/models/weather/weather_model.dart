import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_meteo/open_meteo.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherData {
  final DateTime date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final double uvIndexMax;
  final double precipitationSum;

  WeatherData({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.uvIndexMax,
    required this.precipitationSum,
  });

  static Future<WeatherData> fetchWeatherData(
    double latitude,
    double longitude, {
    String timezone = "America/New_York",
  }) async {
    final weather = WeatherApi();
    final response = await weather.request(
      latitude: latitude,
      longitude: longitude,
      daily: {
        WeatherDaily.weather_code,
        WeatherDaily.temperature_2m_max,
        WeatherDaily.temperature_2m_min,
        WeatherDaily.uv_index_max,
        WeatherDaily.precipitation_sum,
      },
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
    final data = response.dailyData;

    return WeatherData(
      date: DateTime.now(),
      weatherCode:
          data[WeatherDaily.weather_code]!.values.values
              .toList()[0]
              .toInt(),
      temperatureMax:
          data[WeatherDaily.temperature_2m_max]!
              .values
              .values
              .toList()[0]
              .toDouble(),
      temperatureMin:
          data[WeatherDaily.temperature_2m_min]!
              .values
              .values
              .toList()[0]
              .toDouble(),
      uvIndexMax:
          data[WeatherDaily.uv_index_max]!.values.values
              .toList()[0]
              .toDouble(),
      precipitationSum:
          data[WeatherDaily.precipitation_sum]!
              .values
              .values
              .toList()[0]
              .toDouble(),
    );
  }

  (String, IconData) generateWeatherDescription() {
    String description = "";
    IconData icon;

    // Interpret the weather code
    switch (weatherCode) {
      case 0:
        description += "Clear sky.";
        icon = Icons.sunny;
      case 1:
      case 2:
      case 3:
        description += "Some clouds.";
        icon = Icons.cloud;
      case 45:
      case 48:
        description += "Fog or depositing rime fog.";
        icon = Icons.foggy;
      case 51:
      case 53:
      case 55:
        description +=
            "Drizzle with light to dense intensity.";
        icon = WeatherIcons.rain;
      case 56:
      case 57:
        description +=
            "Freezing drizzle with light or dense intensity.";
        icon = WeatherIcons.sleet;
      case 61:
      case 63:
      case 65:
        description +=
            "Rain with slight to heavy intensity.";
        icon = WeatherIcons.rain;
      case 66:
      case 67:
        description +=
            "Freezing rain with light or heavy intensity.";
        icon = WeatherIcons.sleet;
      case 71:
      case 73:
      case 75:
        description +=
            "Snowfall with slight to heavy intensity.";
        icon = WeatherIcons.snow;
      case 77:
        description += "Snow grains.";
        icon = WeatherIcons.snow;
      case 80:
      case 81:
      case 82:
        description +=
            "Rain showers with slight to violent intensity.";
        icon = WeatherIcons.rain;
      case 85:
      case 86:
        description +=
            "Snow showers with slight or heavy intensity.";
        icon = WeatherIcons.snow;
      case 95:
        description +=
            "Thunderstorm with slight or moderate intensity.";
        icon = WeatherIcons.day_snow_thunderstorm;
      case 96:
      case 99:
        description +=
            "Thunderstorm with slight or heavy hail.";
        icon = WeatherIcons.day_snow_thunderstorm;
      default:
        description += "Unknown weather conditions.";
        icon = Icons.sunny;
    }

    // Add temperature information
    description +=
        "The temperature will range from ${temperatureMin.toInt()}°C to ${temperatureMax.toInt()}°C.";

    // Add UV index information
    description +=
        " The maximum UV index will be ${uvIndexMax.toInt()}.";

    // Add precipitation information with qualitative description
    String precipitationDescription;

    if (0 < precipitationSum && precipitationSum <= 1) {
      precipitationDescription =
          "No significant precipitation expected.";
    } else if (1 < precipitationSum &&
        precipitationSum <= 5) {
      precipitationDescription =
          "Light precipitation expected.";
    } else if (5 < precipitationSum &&
        precipitationSum <= 10) {
      precipitationDescription =
          "Moderate precipitation expected.";
    } else if (10 < precipitationSum) {
      precipitationDescription =
          "Heavy precipitation expected.";
    } else {
      precipitationDescription =
          "Unknown precipitation conditions.";
    }

    description += precipitationDescription;

    return (description, icon);
  }
}

import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather.dart';

class WeatherService {
  String apiKey = '7c75856312984912037d8c4ea863d7ef';
  String baseUrl = 'https://api.openweathermap.org/data';
  //TODO conver permition statement to sitch case , and to blocs

  Future<String> getUserCity() async {
    late String city;
    LocationPermission permission = await Geolocator.checkPermission();
    try {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          city = 'Tehran';
        }
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );
        double latitude = position.latitude;
        double longitude = position.longitude;
        List<Placemark> placemark = await placemarkFromCoordinates(
          latitude,
          longitude,
        );
        city = placemark[0].locality!;
      }
      return city;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  Future<Weather> getWeatherData(String city) async {
    try {
      late Weather weather;
      Response response = await Dio().get(
        '$baseUrl/2.5/weather?q=$city&appid=$apiKey&units=metric',
      );
      if (response.statusCode == 200) {
        weather = Weather.fromJson(response.data);
      }
      return weather;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }
}

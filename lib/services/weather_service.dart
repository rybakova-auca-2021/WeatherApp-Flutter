import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'abe29e70ba9b464104a51b15dcfef1be';
  final String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final String baseForecastUrl = 'http://api.openweathermap.org/data/2.5/forecast';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = '$baseUrl?q=$city&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchForecast(String city) async {
    final url = '$baseForecastUrl?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

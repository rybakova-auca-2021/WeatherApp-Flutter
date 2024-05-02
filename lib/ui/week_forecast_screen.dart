import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherIcon {
  final IconData icon;
  final Color color;

  WeatherIcon(this.icon, this.color);
}

class WeeklyForecast extends StatefulWidget {
  const WeeklyForecast({super.key, this.city});

  final City? city;

  @override
  State<WeeklyForecast> createState() => _WeeklyForecastState();
}

class _WeeklyForecastState extends State<WeeklyForecast> {
  final WeatherService _weatherService = WeatherService();
  List<dynamic>? _forecastData;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    try {
      final data = await _weatherService.fetchForecast(widget.city?.city ?? 'London');
      setState(() {
        _forecastData = _groupByDate(data['list']);
      });
    } catch (e) {
      print(e);
    }
  }

  List<dynamic> _groupByDate(List<dynamic> forecastList) {
    final Map<String, dynamic> groupedData = {};

    for (var forecast in forecastList) {
      final date = DateTime.parse(forecast['dt_txt']).toLocal().toString().split(' ')[0];
      if (!groupedData.containsKey(date)) {
        groupedData[date] = forecast;
      }
    }

    return groupedData.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 62, 0, 132), Color.fromARGB(255, 134, 88, 157), Color.fromARGB(255, 0, 0, 0)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_circle_left, color: Colors.white),
                    label: const Text("Back", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 90),
                  Image.asset("assets/showers.png", width: 200, height: 100)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(Icons.date_range, color: Colors.white),
                  const SizedBox(width: 10),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color.fromARGB(255, 200, 80, 0), Color.fromARGB(255, 255, 71, 212)],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds),
                    child: Text(
                      "This Week | ${widget.city?.city.toString()}",
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _forecastData == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _forecastData!.length,
                      itemBuilder: (context, index) {
                        final forecast = _forecastData![index];
                        final dateTime = DateTime.parse(forecast['dt_txt']);
                        final day = _getDayOfWeek(dateTime.weekday);
                        final temp = forecast['main']['temp'];
                        final description = forecast['weather'][0]['description'];
                        final weatherIcon = _getWeatherIcon(forecast['weather'][0]['main']);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white24),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(day, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
                              Row(
                                children: [
                                  Icon(weatherIcon.icon, color: weatherIcon.color, size: 18),
                                  const SizedBox(width: 8),
                                  Text(description, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat')),
                                ],
                              ),
                              Text('${temp.toStringAsFixed(0)}°', style: const TextStyle(color: Colors.white, fontSize: 56, fontFamily: 'Rajdhani')),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  WeatherIcon _getWeatherIcon(String main) {
    switch (main) {
      case 'Clear':
        return WeatherIcon(Icons.wb_sunny, Colors.yellow);
      case 'Clouds':
        return WeatherIcon(Icons.cloud, Colors.grey);
      case 'Rain':
        return WeatherIcon(Icons.beach_access, Colors.blue);
      case 'Thunderstorm':
        return WeatherIcon(Icons.thunderstorm, Colors.purple);
      case 'Snow':
        return WeatherIcon(Icons.ac_unit, Colors.lightBlue);
      default:
        return WeatherIcon(Icons.wb_sunny, Colors.yellow);
    }
  }
}

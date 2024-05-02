import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/ui/week_forecast_screen.dart';
import 'package:weather_app/ui/welcome_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.city});

  final City? city;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final data = await _weatherService.fetchWeather(widget.city?.city ?? 'London');
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherImage(String description) {
    if (description.contains('clear')) {
      return 'assets/clear.png';
    } else if (description.contains('cloud')) {
      return 'assets/heavycloud.png';
    } else if (description.contains('rain')) {
      return 'assets/lightrain.png';
    } else if (description.contains('snow')) {
      return 'assets/snow.png';
    }
    return 'assets/showers.png';
  }

  String _getFormattedDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('EEEE, MMMM d').format(date);
  }

  Widget _buildSunInfo() {
    if (_weatherData == null) {
      return const CircularProgressIndicator();
    }

    final sunrise = DateTime.fromMillisecondsSinceEpoch(_weatherData!['sys']['sunrise'] * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(_weatherData!['sys']['sunset'] * 1000);
    final sunriseTime = DateFormat('h:mm a').format(sunrise);
    final sunsetTime = DateFormat('h:mm a').format(sunset);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            const Icon(Icons.wb_sunny, color: Colors.yellow),
            const SizedBox(width: 10),
            Column(
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Sunrise',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                ),
                Text(
                  sunriseTime,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ],
            ),
            const SizedBox(width: 50),
            const Icon(Icons.nights_stay, color: Colors.blue),
            const SizedBox(width: 10),
            Column(
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Sunset',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                ),
                Text(
                  sunsetTime,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
              },
              icon: const Icon(Icons.map, color: Colors.white),
              label: Text(
                _weatherData != null ? _weatherData!['name'] : '',
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'
                ),
              ),
            ),
            Center(
              child: _weatherData == null
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: 500,
                      height: 580,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${(_weatherData!['main']['temp'] - 273.15).toStringAsFixed(0)}°C',
                                style: const TextStyle(
                                  fontSize: 84,
                                  color: Color.fromARGB(255, 255, 246, 255),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                                ),
                              ),
                              const SizedBox(height: 90),
                              Text(
                                '${_weatherData!['weather'][0]['description']}',
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                              Text(
                                _getFormattedDate(_weatherData!['dt']),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                              const SizedBox(height: 20),
                              TextButton.icon(
                                onPressed: () {
                                   Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WeeklyForecast(city: widget.city),
                                      ),
                                    );
                                },
                                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                                iconAlignment: IconAlignment.end,
                                label: ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Color.fromARGB(255, 190, 110, 196), Colors.orange],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'Next days',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildSunInfo(),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.water_drop,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                      '${_weatherData!['main']['humidity']}%',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat'
                                        ),
                                      ),
                                      const Text(
                                        "Humidity",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Montserrat'
                                          )
                                        )
                                    ],
                                  ),
                                  const SizedBox(width: 70),
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.air,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${_weatherData!['wind']['speed']}km/h',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat'
                                        ),
                                      ),
                                      const Text("Wind speed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          fontFamily: 'Montserrat'
                                        )
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 70),
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.grain,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _weatherData!['rain'] != null
                                            ? '${_weatherData!['rain']['1h']} mm'
                                            : '0 mm',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat'
                                        ),
                                      ),
                                      const Text(
                                        "Rain",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Montserrat'
                                          )
                                        )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                          Positioned(
                            top: 60,
                            child: Image.asset(
                              getWeatherImage(
                                  _weatherData!['weather'][0]['description']),
                              width: 160,
                              height: 160,
                            ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

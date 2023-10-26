import 'dart:convert';
import 'package:flutter/material.dart';
import 'weather_api.dart';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> fetchWeatherData(String city) async {
  final response = await http.get(
      Uri.parse('https://cpsu-test-api.herokuapp.com/api/1_2566/weather/current?city=$city'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to load weather data');
  }
}

class HomePage extends StatefulWidget {
  final String selectedCity;

  HomePage({required this.selectedCity});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>>? weatherData;
  bool isCelsius = true;

  void toggleTemperatureUnit() {
    setState(() {
      isCelsius = !isCelsius;
    });
  }

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeatherData(widget.selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),


      ),

      body: Center(

        child: FutureBuilder<Map<String, dynamic>>(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No Data Available');
            } else {
              final weatherInfo = snapshot.data!;

              final temperatureKey = isCelsius ? 'tempC' : 'tempF';
              final feelsLikeKey = isCelsius ? 'feelsLikeC' : 'feelsLikeF';
              final windSpeedKey = isCelsius ? 'windKph' : 'windMph';

              final temperature = weatherInfo[temperatureKey];
              final feelsLike = weatherInfo[feelsLikeKey];
              final windSpeed = weatherInfo[windSpeedKey];

              final humidity = weatherInfo['humidity'];
              final uv = weatherInfo['uv'];
              final conditionText = weatherInfo['condition']['text'];
              final conditionIconUrl = weatherInfo['condition']['icon'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  Image.network(
                    conditionIconUrl,
                    width: 128,
                    height: 128,
                  ),
                  Text(
                    '${widget.selectedCity}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '${weatherInfo['country']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Temperature: $temperature${isCelsius ? '°C' : '°F'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Feels Like: $feelsLike${isCelsius ? '°C' : '°F'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Wind Speed: $windSpeed ${isCelsius ? 'km/h' : 'mph'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Humidity: $humidity%',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'UV: $uv',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Condition: $conditionText',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (!isCelsius) {
                  toggleTemperatureUnit();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: isCelsius ? Colors.grey : Colors.blue, // Set the colors as needed
              ),
              child: Text(
                '°C',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8), // Reduce the spacing between the buttons
            ElevatedButton(
              onPressed: () {
                if (isCelsius) {
                  toggleTemperatureUnit();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: isCelsius ? Colors.blue : Colors.grey, // Set the colors as needed
              ),
              child: Text(
                '°F',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;



class WeatherApi {
  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final response = await http.get(
      Uri.parse('https://your-api-url.com/api/weather?city=$city'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

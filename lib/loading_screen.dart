import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  _getCurrentWeather() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _locationData = {
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
      };
    });
    _getWeather();
  }

  Future<void> _getWeather() async {
    String requestUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=${_locationData['latitude']}&lon=${_locationData['longitude']}&appid=29d665e9501f799dd6d0bd42d977108e";
    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode != 200) {
      throw Exception('error retrieving weather: ${response.statusCode}');
    }
    setState(() {
      _temperature = jsonDecode(response.body)['main']['temp'] - 273;
      _humidity = jsonDecode(response.body)['main']['humidity'];
      _city = jsonDecode(response.body)['name'];
      _wind = jsonDecode(response.body)['wind']['speed'];
      _precipitation = jsonDecode(response.body)['clouds']['all'];
    });
    print(response.body);
    print(_temperature);
    print(_humidity);
    print(_city);
    print(_wind);
    print(_precipitation);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

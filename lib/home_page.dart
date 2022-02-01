import 'dart:convert';
import 'package:farm_lab/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'custom_widgets/custom_card.dart';
import 'custom_widgets/show_alert_diag.dart';
import 'maps/input_location.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<dynamic, dynamic> _locationData;
  double _temperature = 0;
  http.Client httpClient;
  int _humidity = 0;
  double _wind = 0;
  int _precipitation = 0;
  String _city = "null";
  bool _loading = true;
  bool _celsius = true;
  String _syncTime = "null";

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignout = await showAlertDiag(context,
        title: 'Logout',
        content: 'Are you sure you want to logout',
        DefaultActionText: 'Logout',
        cancelActionText: 'Cancel');
    if (didRequestSignout == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FarmLab',
        ),
        elevation: 2.0,
        actions: [
          FlatButton(
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
            //_confirmSignOut(context),
          )
        ],
      ),
      body: _loading ? _loadingScreen(context) : _buildContents(context),
    );
  }

  Widget _loadingScreen(BuildContext context) {
    if (_locationData == null) {
      _getCurrentWeather();
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildContents(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getWeather,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _celsius = !_celsius;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _celsius
                                      ? "${_temperature.toStringAsFixed(0)}"
                                      : "${(_temperature * 1.8 + 32).toStringAsFixed(0)}",
                                  style: TextStyle(fontSize: 40),
                                ),
                                Opacity(
                                  opacity: 0,
                                  child: Text(
                                    "C",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: Text(
                                    "C",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: _celsius
                                            ? Colors.green
                                            : Colors.black),
                                  ),
                                ),
                                Text(
                                  "|",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                  child: Text(
                                    "F",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: !_celsius
                                            ? Colors.green
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 4, 4, 0),
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () => navigateAndDisplay(context),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.my_location,
                                          size: 15,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          _city,
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],//11 - 15
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Synced ${_syncTime}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomCard(
                            text: "Humidity",
                            value: "${_humidity}%",
                          ),
                          CustomCard(
                            text: "Precipitation",
                            value: "${_precipitation}%",
                          ),
                          CustomCard(
                            text: "Wind",
                            value: "${_wind.toStringAsFixed(0)}%",
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _getCurrentWeather,
                    child: const Icon(Icons.my_location),
                    tooltip: "Google Map",
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () => navigateAndDisplay(context),
                    child: const Icon(Icons.pin_drop_outlined),
                    tooltip: "Google Map",
                  ),
                ],
              ),*/
              const SizedBox(
                height: 2000,
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateAndDisplay(BuildContext context) async {
    final Map<String, dynamic> locationData =
        await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => InputLocation(),
    ));
    print(locationData);
    if (locationData != null) {
      setState(() {
        _locationData = locationData;
      });
      _getWeather();
    }
  }

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
      _syncTime = DateFormat("h:mm:ss a").format(DateTime.now()).toString();
    });
    print(response.body);
    print(_temperature);
    print(_humidity);
    print(_city);
    print(_wind);
    print(_precipitation);
    setState(() {
      _loading = false;
    });
  }
}

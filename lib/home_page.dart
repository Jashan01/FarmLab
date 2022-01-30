import 'dart:convert';
import 'package:farm_lab/services/auth.dart';
import 'package:flutter/material.dart';
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
  double _precipitation = 0;
  String _city;
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
        title: Text(
          'FarmLab',
        ),
        elevation: 2.0,
        actions: [
          FlatButton(
            child: Text('Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                )),
            onPressed: () => _confirmSignOut(context),
            //_confirmSignOut(context),
          )
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
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
                        Row(
                          children: [
                            Text(
                              "28",
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4, 4, 0),
                          width: 300,
                          child: Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Location"),
                              SizedBox(
                                height: 8,
                              ),

                                Text("Synced 9:58 a.m."),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomCard(
                          text: "Humidity",
                          value: "58%",
                        ),
                        CustomCard(
                          text: "Humidity",
                          value: "58%",
                        ),
                        CustomCard(
                          text: "Humidity",
                          value: "58%",
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            FloatingActionButton(
              onPressed: () => navigateAndDisplay(context),
              child: Icon(Icons.pin_drop_outlined),
              tooltip: "Google Map",
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "${_temperature.toStringAsFixed(0)}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "C | F ",
                              style: TextStyle(
                                fontSize: 10.0,
                              ),
                            ),
                            FlatButton(
                              child: Row(
                                children: [
                                  Icon(Icons.pin_drop_outlined),
                                  Text("${_city}"),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Text("${_temperature.toStringAsFixed(0)}"),
            // SizedBox(
            //   height: 20,
            // ),
            // Text("${_city}"),
            // SizedBox(
            //   height: 20,
            // ),
            // Text("${_wind}"),
            // SizedBox(
            //   height: 20,
            // ),
            // Text("${_humidity}"),
          ],
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
      _precipitation = jsonDecode(response.body)['cloyds']['all'];
    });
    print(response.body);
    print(_temperature);
  }
}

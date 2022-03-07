import 'dart:convert';
import 'package:farm_lab/profile/user_profile.dart';
import 'package:farm_lab/bluetooth/MainPage.dart';
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
  // int pageIndex = 0;

  // final pages = [
  //   HomePage(),
  //   UserProfile(),
  // ];

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 844);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 390);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'FarmLab',
            style: TextStyle(
              color: Color(0xFF151515),
              fontSize: pW(18),
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0.0,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(16), pH(8), 0, pH(8)),
            child: Container(
              child: Icon(
                Icons.add_rounded,
                size: 20,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF151515)),
            ),
          ),
          actions: [
            Icon(
              Icons.notifications_none,
              size: pW(24),
              color: Color(0xFF151515),
            ),
            FlatButton(
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Color(0xFF151515),
                ),
              ),
              onPressed: () => _confirmSignOut(context),
              //_confirmSignOut(context),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _loading ? _loadingScreen(context) : _buildContents(context),
            ],
          ),
        ),
      ),
      body: _loading ? _loadingScreen(context) : _buildContents(context),
      //body: pages[pageIndex],
      // bottomNavigationBar: Container(
      //   height: 20,
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).primaryColor,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(5),
      //       topRight: Radius.circular(5),
      //     ),
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children:  _buildNavigtaorChildren(),
      //   ),
      // ),
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
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(pW(16), pH(24), pW(16), 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                color: Color(0xFF151515),
                fontSize: pW(24),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: pH(12),
            ),
            Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(pW(8)),
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
                              style: TextStyle(
                                color: Color(0xFF151515),
                                fontSize: pW(54),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Opacity(
                              opacity: 0,
                              child: Text(
                                "C",
                                style: TextStyle(fontSize: pW(16)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: Text(
                                "C",
                                style: TextStyle(
                                    fontSize: pW(16),
                                    color: _celsius
                                        ? Color(0xFF008B61)
                                        : Colors.black),
                              ),
                            ),
                            Text(
                              "|",
                              style: TextStyle(fontSize: pW(16)),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                "F",
                                style: TextStyle(
                                    fontSize: pW(16),
                                    color: !_celsius
                                        ? Color(0xFF008B61)
                                        : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () => navigateAndDisplay(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.my_location,
                                      size: pW(18),
                                      color: Color(0xFF008B61),
                                    ),
                                    SizedBox(
                                      width: pW(4),
                                    ),
                                    Text(
                                      _city,
                                      style: TextStyle(
                                          color: Color(0xFF151515),
                                          fontSize: pW(17)),
                                    ),
                                  ], //11 - 15
                                )),
                            SizedBox(
                              height: pH(4),
                            ),
                            Text(
                              "Synced ${_syncTime}",
                              style: TextStyle(
                                fontSize: pW(15),
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: pH(6),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomCard(
                        text: "Humidity",
                        value: "${_humidity}%",
                        fsize1: pW(12),
                        fsize2: pW(24),
                        ht: pW(32),
                        wd: pW(110),
                        br: pW(6)),
                    CustomCard(
                        text: "Precipitation",
                        value: "${_precipitation}%",
                        fsize1: pW(12),
                        fsize2: pW(24),
                        ht: pW(32),
                        wd: pW(110),
                        br: pW(6)),
                    CustomCard(
                        text: "Wind",
                        value: "${_wind.toStringAsFixed(0)}%",
                        fsize1: pW(12),
                        fsize2: pW(24),
                        ht: pW(32),
                        wd: pW(110),
                        br: pW(6))
                  ],
                ),
              ],
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
            SizedBox(
              height: pW(18),
            ),
            Padding(
              padding: EdgeInsets.all(pW(10)),
              child: Divider(
                color: Color(0xFFBDBDBD),
                thickness: 0.5,
              ),
            ),
            Text(
              'Soil Health',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: pW(20),
                  color: Color(0xFF151515),
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: pW(12),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    new BoxShadow(
                        color: Color(0xFFBDBDBD).withOpacity(0.4),
                        spreadRadius: 0.5,
                        blurRadius: 2.0,
                        offset: Offset(1, 2)),
                  ]),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    pW(10), pW(12), pW(12), pW(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crop',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: pW(11),
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: pW(6),
                            ),
                            Text(
                              'Wheat',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: pW(24),
                                  color: Color(0xFF008B61),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Nature: Neutral (pH 7)',
                              style: TextStyle(
                                  fontSize: pW(12),
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              height: pW(4),
                            ),
                            Text(
                              'Moisture: 78%',
                              style: TextStyle(
                                  fontSize: pW(12),
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: pW(30),
                    ),
                    Text(
                      'Soil Content',
                      style: TextStyle(
                          fontSize: pW(10),
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: pW(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '40 ppm',
                              style: TextStyle(
                                  fontSize: pW(22),
                                  color: Color(0xFF151515),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: pW(6),
                            ),
                            Text(
                              'Nitrogen',
                              style: TextStyle(
                                  fontSize: pW(13),
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),

                        // VerticalDivider(
                        //   color: Color(0xFFCECECE),
                        //   thickness: 0.5,
                        // ),

                        Container(
                          height: pW(42),
                          width: 1.0,
                          color: Color(0xFFCECECE),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '30 ppm',
                              style: TextStyle(
                                  fontSize: pW(22),
                                  color: Color(0xFF151515),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: pW(6),
                            ),
                            Text(
                              'Phosphorus',
                              style: TextStyle(
                                  fontSize: pW(13),
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),

                        Container(
                          height: pW(42),
                          width: 1.0,
                          color: Color(0xFFCECECE),
                        ),

                        // VerticalDivider(
                        //   color: Color(0xFF000000),
                        //   thickness: 5,
                        //
                        // ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '140 ppm',
                              style: TextStyle(
                                  fontSize: pW(22),
                                  color: Color(0xFF151515),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: pW(6),
                            ),
                            Text(
                              'Potassium',
                              style: TextStyle(
                                  fontSize: pW(13),
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: pW(18),
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFCECECE),
                    ),
                    SizedBox(
                      height: pW(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Soil: ',
                              style: TextStyle(
                                  fontSize: pW(15),
                                  color: Color(0xFF151515),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Healthy',
                              style: TextStyle(
                                  fontSize: pW(16),
                                  color: Color(0xFF008B61),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Synced 30 Days Ago ',
                              style: TextStyle(
                                  fontSize: pW(13),
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.wifi_protected_setup_sharp,
                              color: Color(0xFF008B61),
                              size: pW(20),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => MainPage(),
                ));
              },
              child: Text('Connect to Device'),
            ),
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

  // List<Widget> _buildNavigtaorChildren() {
  //   return [
  //     IconButton(
  //       enableFeedback: false,
  //       onPressed: () {
  //         setState(() {
  //           pageIndex = 0;
  //         });
  //       },
  //       icon: const Icon(
  //         Icons.home_outlined,
  //         color: Colors.black,
  //         size: 35,
  //       ),
  //     ),
  //     IconButton(
  //       enableFeedback: false,
  //       onPressed: () {
  //         setState(() {
  //           pageIndex = 1;
  //         });
  //       },
  //       icon: const Icon(
  //         Icons.work_outline_outlined,
  //         color: Colors.black,
  //         size: 35,
  //       ),
  //     ),
  //   ];
  // }
}

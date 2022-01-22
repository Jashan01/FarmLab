
import 'package:farm_lab/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_widgets/show_alert_diag.dart';
import 'maps/input_location.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<dynamic, dynamic> _locationData;
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
    return Padding(
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
          FloatingActionButton(
            onPressed: () => navigateAndDisplay(context),
            child: Icon(Icons.pin_drop_outlined),
            tooltip: "Google Map",
          )
        ],
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
    }
  }
}

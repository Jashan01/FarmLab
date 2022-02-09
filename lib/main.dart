
import 'package:farm_lab/app/sign_in_page.dart';
import 'package:farm_lab/landing_page.dart';
import 'package:farm_lab/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_lab/home_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color =
    {
      50:Color.fromRGBO(0,139,97, .1),
      100:Color.fromRGBO(0,139,97, .2),
      200:Color.fromRGBO(0,139,97, .3),
      300:Color.fromRGBO(0,139,97, .4),
      400:Color.fromRGBO(0,139,97, .5),
      500:Color.fromRGBO(0,139,97, .6),
      600:Color.fromRGBO(0,139,97, .7),
      700:Color.fromRGBO(0,139,97, .8),
      800:Color.fromRGBO(0,139,97, .9),
      900:Color.fromRGBO(0,139,97, 1),
    };
    MaterialColor colorCustom = MaterialColor(0xFF008B61, color);
      return Provider<AuthBase>(
        create: (context) => Auth(),
        child: MaterialApp(
          title: 'FarmLab',
          theme: ThemeData(
            primarySwatch: colorCustom,
          ),
          home: HomePage(),
    ),
      );
  }
}


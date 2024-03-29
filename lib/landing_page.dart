import 'package:farm_lab/profile/user_profile.dart';
import 'package:farm_lab/services/auth.dart';
import 'package:farm_lab/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'app/sign_in_page.dart';


class LandingPage extends StatelessWidget {
  //const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User> (
      stream: auth.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          print(user.toString());
          // return Provider<Database>(
          //   create: (_) => FirestoreDatabase(uid: user.uid),
          //   child: LoaderPage(),
          // );
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomePage(),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          )
        );
      },
    );
  }
}

import 'package:drivers_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/AllScreens/loginScreen.dart';
import 'package:drivers_app/AllScreens/mainscreen.dart';
import 'package:drivers_app/AllScreens/registrationScreen.dart';
import 'package:drivers_app/DataHandler/appData.dart';
import 'package:drivers_app/AllScreens/carInfoScreen.dart';

import 'AllScreens/welcomeScreen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestsRef = FirebaseDatabase.instance.reference().child("Ride Requests");
DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("drivers").child(currentfirebaseUser.uid).child("newRide");



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Tricycle Driver App',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? WelcomeScreen.idScreen : MainScreen.idScreen,
        routes:
        {
           WelcomeScreen.idScreen: (context) => WelcomeScreen(),
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
        },

        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


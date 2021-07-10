import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/registration_screen.dart';
import 'package:first_project/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'registration_screen.dart';
import 'components/rounded_button.dart';
import 'login_screen.dart';
import 'weather_screen.dart';
import 'add_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WeatherScreen.id: (context) => WeatherScreen(),
        AddLocation.id: (context) => AddLocation(),
      },
    );
  }
}

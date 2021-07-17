import 'package:first_project/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/summoner_search.dart';
import 'screens/add_location.dart';
import 'screens/set_summoner_name.dart';

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
        SummonerSearch.id: (context) => SummonerSearch(),
        AddLocation.id: (context) => AddLocation(),
        SetSummonerName.id: (context) => SetSummonerName(),
        MainScreen.id: (context) => MainScreen(),
      },
    );
  }
}

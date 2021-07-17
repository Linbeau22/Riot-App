import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/screens/summoner_search.dart';
import 'package:flutter/material.dart';
import 'set_summoner_name.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const id = '/mainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  bool summonerExists = false;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
    // here you write the codes to input the data into firestore
  }

  // checkIfSummonerExists(AsyncSnapshot<QuerySnapshot> snapshot) {
  //   return snapshot.data!.docs.map((docs) {
  //     if (docs['summonerName'] == null) {
  //       Navigator.pushNamed(context, SetSummonerName.id);
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Main Screen'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, SummonerSearch.id),
              icon: Icon(Icons.search_off_rounded),
            ),
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream: usersCollection
                .doc(_auth.currentUser!.uid)
                .collection('Summoner Info')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // checkIfSummonerExists(snapshot);
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print('summoner name:');
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Center(
                    child: ListTile(
                      title: Text('Name:' + document['summonerName']),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

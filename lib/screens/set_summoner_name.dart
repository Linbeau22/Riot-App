import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/components/rounded_button.dart';
import 'package:first_project/components/constants.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';

class SetSummonerName extends StatefulWidget {
  static const id = '/setSummonerName';

  const SetSummonerName({Key? key}) : super(key: key);

  @override
  _SetSummonerNameState createState() => _SetSummonerNameState();
}

class _SetSummonerNameState extends State<SetSummonerName> {
  TextEditingController _summonerField = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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

  Future updateSummonerName(String summonerName) async {
    return await usersCollection
        .doc(loggedInUser.uid)
        .collection('Summoner Info')
        .doc()
        .set({'summonerName': summonerName});
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register your Summoner!'),
        actions: [
          FloatingActionButton(
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _summonerField,
              textAlign: TextAlign.center,
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Summoner name'),
            ),
            SizedBox(height: 10.0),
            RoundedButton(
                label: 'Submit',
                onPressed: () async {
                  await updateSummonerName(_summonerField.text);
                  Navigator.pushNamed(context, MainScreen.id);
                },
                color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}

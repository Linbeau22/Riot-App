import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/screens/display_summoner_info.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/rounded_button.dart';
import '../components/constants.dart';

class SummonerSearch extends StatefulWidget {
  const SummonerSearch({Key? key}) : super(key: key);

  static const id = '/weather';

  @override
  _SummonerSearchState createState() => _SummonerSearchState();
}

class _SummonerSearchState extends State<SummonerSearch> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;

  bool showSpinner = false;

  TextEditingController _summonerField = TextEditingController();

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

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ]),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                controller: _summonerField,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Summoner name'),
              ),
              SizedBox(
                height: 10.0,
              ),
              RoundedButton(
                label: 'Enter',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  // var summonerData =
                  //     await DataModel().fetchByName('Kitchen Counter');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplaySummonerInfo(
                          summonerName: _summonerField.text),
                    ),
                  );
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

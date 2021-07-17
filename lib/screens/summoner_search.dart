import 'package:cloud_firestore/cloud_firestore.dart';
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

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.logout_sharp),
//               onPressed: () {
//                 _auth.signOut();
//                 Navigator.pop(context);
//               }),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//         ),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Center(
//           child: StreamBuilder(
//             //turns snapshots of data into actual widgets. setState() gets called everytime new data enters the stream
//             stream:
//                 FirebaseFirestore.instance //stream: where the data comes from
//                     .collection('Users')
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .collection('Coins')
//                     .snapshots(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               return Expanded(
//                 child: ListView(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//                   children: snapshot.data!.docs.map(
//                     //list of documents found in firestore. ListView is iterating each document. for each document, return a container
//                     (document) {
//                       return Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text('Coin name: ${document.id}'),
//                             Text('Amount owed: ${document['Amount']}'),
//                           ],
//                         ),
//                       );
//                     },
//                   ).toList(),
//                 ),
//               ); // if snapshot does have data, return this listview of data
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.account_tree_outlined),
//         onPressed: () {
//           Navigator.pushNamed(context, AddLocation.id);
//         },
//       ),
//     );
//   }
}

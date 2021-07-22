import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/components/constants.dart';
import 'package:first_project/network/api.dart';
import 'package:first_project/screens/summoner_search.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:first_project/network/api.dart';

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

  Color rankTextColor(String tier) {
    if (tier == 'IRON') {
      return Colors.grey.shade900;
    } else if (tier == 'BRONZE') {
      return Color(0xffcdf732);
    } else if (tier == 'SILVER') {
      return Color(0xffc0c0c0);
    } else if (tier == 'GOLD') {
      return Color(0xfff9c00c);
    } else if (tier == 'PLATINUM') {
      return Color(0xffe5e4e2);
    } else if (tier == 'DIAMOND') {
      return Color(0xffb9f2ff);
    } else if (tier == 'MASTER') {
      return Colors.red.shade800;
    } else if (tier == 'CHALLENGER') {
      return Color(0xfff9c00c);
    } else {
      return Colors.black;
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SourceCodePro'),
      home: Scaffold(
        backgroundColor: Colors.purple.shade900,
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade700,
          title: Text(
            'Flutter.gg',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'FrizQuadrata',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, SummonerSearch.id),
              icon: Icon(Icons.search_off_rounded),
            ),
            IconButton(
              icon: Icon(Icons.logout_rounded),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.pushNamed(context, LoginScreen.id);
                } catch (e) {
                  print(e);
                }
              },
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
              print(snapshot.data!.docs[0].data().toString());

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          document['summonerName'],
                          style: kDefaultTextStyle,
                        ),
                      ),
                      Container(
                        child: FutureBuilder<dynamic>(
                          future:
                              DataModel().fetchRank(document['summonerName']),
                          builder: (context, snapshot) {
                            String tier;
                            String rank;
                            try {
                              //if successful, the player is ranked and has data
                              if (snapshot.hasData) {
                                tier = snapshot.data![0]['tier'];
                                rank = snapshot.data![0]['rank'];
                              } else {
                                return CircularProgressIndicator();
                              }
                              if (tier == 'CHALLENGER' ||
                                  tier == 'MASTER' ||
                                  tier == 'GRANDMASTER') {
                                rank = '';
                              }
                              String tierRank = tier + ' ' + rank;
                              return Center(
                                child: Text(
                                  tierRank,
                                  style: kDefaultTextStyle.copyWith(
                                      color: rankTextColor(tier)),
                                ),
                              );
                            } catch (e) {
                              //if unsuccessful call from api, means the player is unranked and json is empty
                              return Center(
                                child: Text('Unranked'),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        child: FutureBuilder<dynamic>(
                          future: DataModel().fetchTopMasteryChampion(
                              document['summonerName']),
                          builder: (context, snapshot) {
                            String champID;
                            String champMasteryLevel;
                            String champMasteryPoints;
                            String masteryIcon;
                            int champMasteryLevelInt;
                            try {
                              if (snapshot.hasData) {
                                champID =
                                    snapshot.data![0]['championId'].toString();
                                champMasteryLevel = snapshot.data![0]
                                        ['championLevel']
                                    .toString();
                                champMasteryPoints = snapshot.data![0]
                                        ['championPoints']
                                    .toString();
                                champMasteryLevelInt =
                                    int.parse(champMasteryLevel);

                                // masteryIcon =
                                // 'Champion_Mastery_Level_${champMasteryLevel}_Flair.png';
                              } else {
                                return CircularProgressIndicator();
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: ChampionName(champID: champID),
                                  ),
                                  SizedBox(height: 10),
                                  FutureBuilder(
                                    future: DataModel()
                                        .fetchChampionNameByID(champID),
                                    builder: (context, snapshot) {
                                      String champName;
                                      if (snapshot.hasData) {
                                        champName = snapshot.data.toString();
                                        champName = champName.toLowerCase();
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'images/champ_splashes/${champName}_splash.jpg'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'images/mastery_icons/Champion_Mastery_Level_${champMasteryLevelInt}_Flair.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } catch (e) {
                              print(e);
                              return Placeholder();
                            }
                          },
                        ),
                      ),
                      Container(
                        child: FutureBuilder(
                          future: DataModel().fetchHighestChampionWinrate(
                              document['summonerName'], 420),
                          builder: (context, snapshot) {
                            Map championWithHighestWinrateMap = {};
                            String championWithHighestWinrateName = '';
                            double winrate = 0;
                            if (snapshot.hasData) {
                              championWithHighestWinrateMap =
                                  snapshot.data as Map;
                              championWithHighestWinrateMap
                                  .forEach((key, value) {
                                championWithHighestWinrateName = key;
                                winrate = value;
                                print(key);
                                print(value);
                              });
                            } else {
                              print('no data');
                              return CircularProgressIndicator();
                            }
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Highest Champion Win Percentage in Ranked: ',
                                    style: kDefaultTextStyle.copyWith(
                                        fontSize: 12),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        championWithHighestWinrateName,
                                        style: kDefaultTextStyle.copyWith(
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        (winrate * 100).toString() + '%',
                                        style: kDefaultTextStyle.copyWith(
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

class ChampionName extends StatefulWidget {
  final String champID;

  ChampionName({required this.champID});

  @override
  _ChampionNameState createState() => _ChampionNameState();
}

class _ChampionNameState extends State<ChampionName> {
  String champName = '';

  Future<String> fetchChampName(String champID) async {
    return await DataModel().fetchChampionNameByID(champID);
  }

  @override
  void initState() {
    fetchChampName(widget.champID).then((val) {
      setState(() {
        champName = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      champName,
      style: TextStyle(
        fontFamily: 'SourceCodePro',
      ),
    );
  }
}

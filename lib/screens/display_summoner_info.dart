import 'package:flutter/material.dart';
import '../network/api.dart';

class DisplaySummonerInfo extends StatefulWidget {
  final summonerName;
  static const id = '/display_summoner_info';

  DisplaySummonerInfo({required this.summonerName});

  @override
  _DisplaySummonerInfoState createState() => _DisplaySummonerInfoState();
}

class _DisplaySummonerInfoState extends State<DisplaySummonerInfo> {
  String tier = 'NaN';
  String rank = 'NaN';
  var rankData;
  DataModel rankObj = DataModel();

  void updateTier(summonerName) async {
    setState(() async {
      tier = await getTier(summonerName);
    });
  }

  void updateRank(summonerName) async {
    setState(() async {
      rank = await getRank(summonerName);
    });
  }

  void updateAll(summonerName) async {
    updateTier(summonerName);
    updateRank(summonerName);
  }

  Future<String> getTier(summonerName) async {
    var rankData = await rankObj.fetchRank(summonerName);
    print('In getRank method');
    return rankData[0]['tier'];
  }

  Future<String> getRank(summonerName) async {
    var rankData = await rankObj.fetchRank(summonerName);
    return rankData[0]['rank'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FloatingActionButton(
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Container(
        child: Card(
          child: FutureBuilder<dynamic>(
            future: DataModel().getWholeRank(widget.summonerName),
            builder: (context, snapshot) {
              String tier;
              try {
                //if successful, the player is ranked and has data
                if (snapshot.hasData) {
                  tier = snapshot.data![0]['tier'];
                  rank = snapshot.data![0]['rank'];
                } else {
                  return CircularProgressIndicator();
                }
                if (tier == 'CHALLENGER' || tier == 'MASTER') {
                  rank = '';
                }
                return Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(tier),
                      SizedBox(width: 2.0),
                      Text(rank),
                    ],
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
      ),
    );
  }
}

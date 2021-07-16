import 'package:flutter/material.dart';
import 'network/api.dart';

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

  // void updateUI(dynamic rankData) {
  //   setState(() {
  //     if (rankData == null) {
  //       tier = 'NaN';
  //     }
  //     tier = rankData[0]['tier'];
  //   });
  // }

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

  Future<dynamic> getWholeRank(summonerName) async {
    var rankData = await rankObj.fetchRank(summonerName);
    return rankData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // updateTier(widget.summonerName);
    // updateRank(widget.summonerName);
    return Scaffold(
      body: Container(
        child: Card(
          child: FutureBuilder<dynamic>(
            future: getWholeRank(widget.summonerName),
            builder: (context, snapshot) {
              String tier;
              if (snapshot.hasData) {
                tier = snapshot.data![0]['tier'];
                rank = snapshot.data![0]['rank'];
              } else {
                return CircularProgressIndicator();
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
            },
          ),
        ),
      ),
    );
  }
}

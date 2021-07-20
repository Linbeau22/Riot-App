import 'dart:core';
import 'dart:typed_data';
import 'networking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const api_key = 'RGAPI-59d0f5d3-76c5-4d39-b8fc-987a1e090356';

String removeSpaces(String name) {
  for (int i = 0; i < name.length; i++) {
    if (name[i] == ' ') {
      name = name.replaceRange(i, i + 1, '%20');
    }
  }
  return name;
}

class DataModel {
  Future<String> fetchByName(String name, [String ch = 'default']) async {
    name = removeSpaces(name);
    NetworkHelper networkHelper = NetworkHelper(
        'https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$name?api_key=$api_key');

    var nameData = await networkHelper.getData(ch: ch);

    return nameData;
  }

  Future<dynamic> fetchRank(String name) async {
    name = removeSpaces(name);
    String id = await fetchByName(name, 'id');
    NetworkHelper networkHelper = NetworkHelper(
        'https://na1.api.riotgames.com/lol/league/v4/entries/by-summoner/$id?api_key=$api_key');

    var rankData = await networkHelper.getRankData();
    return rankData;
  }

  Future<dynamic> fetchTopMasteryChampion(String name) async {
    name = removeSpaces(name);
    String id = await fetchByName(name, 'id');
    NetworkHelper networkHelper = NetworkHelper(
        'https://na1.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/$id?api_key=$api_key');
    var masteryData = await networkHelper.getTopMasteryChampionData();
    return masteryData;
  }

  Future<String> fetchChampionNameByID(String id) async {
    http.Response response = await http.get(Uri.parse(
        'https://ddragon.leagueoflegends.com/cdn/11.13.1/data/en_US/champion.json'));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      Map<String, dynamic> champList = decodedData['data'];
      for (var i in champList.keys) {
        var value = champList[i];
        for (var j in value.keys) {
          if (champList[i][j] == id) {
            return champList[i]['name'];
          }
        }
      }
      print('champ not found');
      return 'null';
    } else {
      print('Failed! Status code: ');
      print(response.statusCode);
      return 'error';
    }
  }

  Future<String> fetchChampionImageByID(String id) async {
    http.Response response = await http.get(Uri.parse(
        'https://ddragon.leagueoflegends.com/cdn/11.13.1/data/en_US/champion.json'));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      Map<String, dynamic> champList = decodedData['data'];
      String champName = await fetchChampionNameByID(id);
      return champList[champName]['image']['full'];
    } else {
      print('Failed! Status code: ');
      print(response.statusCode);
      return 'error';
    }
  }

  Future<dynamic> fetchMatchList(String summonerName, int queueType) async {
    String puuid = await fetchByName(summonerName, 'puuid');
    http.Response response = await http.get(Uri.parse(
        'https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/$puuid/ids?api_key=$api_key&queue=420&start=0&count=100'));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    } else {
      print('Failed in fetchMatchList: ');
      print(response.statusCode);
    }
  }

  Future<Map> fetchHighestChampionWinrate(
      String summonerName, int queue) async {
    Map championWinrates = {};
    Map returnMap = {};
    List<int> winLoss = [0, 0]; //overall winrate

    var matchList = await fetchMatchList(summonerName, queue);

    String matchID;
    bool win = false;
    late String championName;
    int participantID = 0;
    http.Response response;
    var decodedData;

    for (var i in matchList) {
      //not printing anything in matchList because it needs to be awaited
      //i is the matchID itself
      matchID = i;

      String matchURL =
          'https://americas.api.riotgames.com/lol/match/v5/matches/$matchID?api_key=$api_key';
      response = await http.get(Uri.parse(matchURL));

      if (response.statusCode == 200) {
        String matchInfo = response.body;
        decodedData = jsonDecode(matchInfo);
      } else {
        print('Failed in fetchHighestChampionWinrate: ');
        print(response.statusCode);
      }

      for (var player in decodedData['info']['participants']) {
        if (player['summonerName'] == summonerName) {
          participantID = player['participantId'];
          championName = player['championName'];
          win = player['win'];
          break;
        }
      }

      //Calculate win loss ratio
      if (win) {
        winLoss[0] += 1;
        if (championWinrates.containsKey(championName)) {
          championWinrates[championName]?[0] += 1;
        } else {
          championWinrates[championName] = [1, 0, 0];
        }
      } else {
        winLoss[1] += 1;
        if (championWinrates.containsKey(championName)) {
          championWinrates[championName]?[1] += 1;
        } else {
          championWinrates[championName] = [0, 1, 0];
        }
      }
      championWinrates[championName]?[2] += 1;
    }

    //Find champion with highest winrate
    double highestWinPercentage = 0;
    double percent;
    String highestWinRateChampion = '';
    championWinrates.forEach((key, value) {
      percent = value[0] / value[2];
      if (percent > highestWinPercentage) {
        highestWinPercentage = percent;
        highestWinRateChampion = key;
      }
    });

    returnMap = {
      highestWinRateChampion: highestWinPercentage,
    };

    return returnMap;
  }
}

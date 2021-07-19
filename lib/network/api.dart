import 'dart:core';
import 'networking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const api_key = 'RGAPI-700c282f-aca9-4b09-bc1f-053d86ec9e5f';

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
}

import 'dart:core';
import 'networking.dart';

const api_key = 'RGAPI-d8a47b44-d64e-4b9e-a265-8632bc381379';

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

  Future<dynamic> getWholeRank(summonerName) async {
    var rankData = await this.fetchRank(summonerName);
    return rankData;
  }
}

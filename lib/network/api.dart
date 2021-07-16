import 'dart:core';
import 'networking.dart';
import 'package:flutter/material.dart';

const api_key = 'RGAPI-27dc7545-289c-49ea-871c-490f29e62894';

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
}

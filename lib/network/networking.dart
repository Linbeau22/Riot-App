import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData({String ch = 'default'}) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;

      // print(data);

      var decodedData = jsonDecode(data);

      if (ch == 'default') {
        print(decodedData);
        return decodedData; //returns map of data
      } else {
        //Options: id, accountID, name, puuid, profileIconID, revisionDate, summonerLevel,
        print(decodedData[ch]);
        return decodedData[ch];
      }
    } else {
      print('Status code: ');
      print(response
          .statusCode); //if doesn't work, it will print status code (200 is good, 400 etc. is bad)
    }
  }

  Future getRankData({String ch = 'default'}) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);
      // print(decodedData[0]['tier']);
      return decodedData;
    } else {
      print('Failed! Status code: ');
      print(response
          .statusCode); //if doesn't work, it will print status code (200 is good, 400 etc. is bad)
    }
  }
}

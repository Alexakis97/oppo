import 'dart:async';
import 'dart:convert';
import '../model/country.dart';
import 'package:http/http.dart' as http;

class FetchCountry {
  static Future<Country> fetchCountry(country) async {
    print('calling' +
        "https://covid-193.p.rapidapi.com/statistics?country=$country");
    var json = await http.get(
        "https://covid-193.p.rapidapi.com/statistics?country=$country",
        headers: {
          "x-rapidapi-host": "covid-193.p.rapidapi.com",
          "x-rapidapi-key":
              "f110062c4cmsh66c661bb3cedefbp12df06jsn1bbd64fee4ac",
          "useQueryString": "true"
        });
    var jsonBody = jsonDecode(json.body);
    int results = jsonBody['results'];
    if (results != 0) {
      var response = jsonBody['response'];
      String continent = (response[0])['continent'];
      String countryR = (response[0])['country'];
      int population = (response[0])['population'];
      var cases = response[0]['cases'];
      var deaths = response[0]['deaths'];
      String newcases = cases['new'];
      int activecases = cases['active'];
      int criticalcases = cases['critical'];
      int recoveredcases = cases['recovered'];
      int totalcases = cases['total'];
      String newdeaths = deaths['new'];
      int totaldeaths = deaths['total'];
      String day = (response[0])['day'];

      print('fetch ok');
      //
      // return jsonEncode(Country(
      //     continent: continent,
      //     country: countryR,
      //     population: population,
      //     newcases: newcases,
      //     activecases: activecases,
      //     criticalcases: criticalcases,
      //     recoveredcases: recoveredcases,
      //     totalcases: totalcases,
      //     newdeaths: newdeaths,
      //     totaldeaths: totaldeaths,
      //     day: day));



      return Country(
          continent: continent,
          country: countryR,
          population: population,
          newcases: newcases,
          activecases: activecases,
          criticalcases: criticalcases,
          recoveredcases: recoveredcases,
          totalcases: totalcases,
          newdeaths: newdeaths,
          totaldeaths: totaldeaths,
          day: day);
    } else {
      return Future.error("Not a country");
    }
  }
}

import 'dart:async';
import 'dart:convert';
import '../model/country.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class FetchCountry {
  static final List<String> datesToSearch = [];

  static initData() {
    final date = DateTime.now();

    for (var i = 1; i <= 5; i++) {
      datesToSearch.add(('${new DateTime(date.year, date.month, date.day - i)}'
          .split(' '))[0]);
    }

    print('function called');
    datesToSearch.forEach((date) => {print('Date to call: $date')});
  }

  static Future<String> fetchCountry(country) async {
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
      int recovered = cases['recovered'];
      int totalcases = cases['total'];
      String newdeaths = deaths['new'];
      int totaldeaths = deaths['total'];
      String day = (response[0])['day'];

      print('fetch ok');

      return jsonEncode(Country(
          continent: continent,
          country: countryR,
          population: population,
          newcases: newcases,
          activecases: activecases,
          recoveredcases: recovered,
          criticalcases: criticalcases,
          totalcases: totalcases,
          newdeaths: newdeaths,
          totaldeaths: totaldeaths,
          day: day));
    } else {
      print('error thrown');
      return Future.error("Not a country");
    }
  }

  static Future<List<FlSpot>> getSpotsFor(searchFor, mapCountryList) async {
    print('trying to get spot for: $mapCountryList');
    List<FlSpot> chartPoints = [];
    switch (searchFor) {
      case "Total Cases":
        for (var i = 0; i < mapCountryList.length; i++) {
          chartPoints.add(
              FlSpot(i.toDouble(), mapCountryList[i].totalcases.toDouble()));
        }
        return chartPoints;
        break;
      case "Total Deaths":
        for (var i = 0; i < mapCountryList.length; i++) {
          chartPoints.add(
              FlSpot(i.toDouble(), mapCountryList[i].totaldeaths.toDouble()));
        }
        return chartPoints;
        break;
      case "Recovered":
        for (var i = 0; i < mapCountryList.length; i++) {
          chartPoints.add(FlSpot(
              i.toDouble(), mapCountryList[i].recoveredcases.toDouble()));
        }
        return chartPoints;
        break;
      case "New Cases":
        for (var i = 0; i < mapCountryList.length; i++) {
          chartPoints.add(FlSpot(
              i.toDouble(),
              (int.parse(mapCountryList[i].newcases.replaceAll('+', '')))
                  .toDouble()));
        }
        return chartPoints;
        break;
      case "Critical":
        for (var i = 0; i < mapCountryList.length; i++) {
          chartPoints.add(
              FlSpot(i.toDouble(), mapCountryList[i].criticalcases.toDouble()));
        }
        return chartPoints;
        break;
      case "New Deaths":
        for (var i = 0; i < mapCountryList.length; i++) {
          chartPoints.add(FlSpot(
              i.toDouble(),
              (int.parse(mapCountryList[i].newdeaths.replaceAll('+', '')))
                  .toDouble()));
        }
        return chartPoints;
        break;
      default:
    }
    return chartPoints;
  }

  static Future<List<Country>> getNewCasesChart(country) async {
    List<Country> mapCountryList = [];
    for (var i = 0; i < datesToSearch.length; i++) {
      print('called first date: ${datesToSearch[i]}');
      var json = await http.get(
          "https://covid-193.p.rapidapi.com/history?country=$country&day=${datesToSearch[i]}",
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
        var cases = response[0]['cases'];
        var deaths = response[0]['deaths'];
        String newcases = cases['new'];
        int activecases = cases['active'];
        int criticalcases = cases['critical'];
        int recoveredcases = cases['recovered'];
        int totalcases = cases['total'];
        String newdeaths = deaths['new'];
        int totaldeaths = deaths['total'];
        mapCountryList.add(Country(
            newcases: newcases,
            activecases: activecases,
            criticalcases: criticalcases,
            recoveredcases: recoveredcases,
            totalcases: totalcases,
            newdeaths: newdeaths,
            totaldeaths: totaldeaths));
      }
      print('added to map');
    }
    return mapCountryList;
  }

  static DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
}

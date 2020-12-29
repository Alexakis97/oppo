import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oppo/functions/fetchcountry.dart';
import 'package:oppo/model/country.dart';

import '../../constants.dart';

class LineReportChart extends StatefulWidget {
  final String searchFor;
  final List<Country> list;
  LineReportChart({this.searchFor, this.list});
  @override
  _LineReportChart createState() =>
      _LineReportChart(searchFor: searchFor, list: list);
}

class _LineReportChart extends State<LineReportChart> {
  String searchFor;
  final List<Country> list;
  _LineReportChart({this.searchFor, this.list});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FetchCountry.getSpotsFor(searchFor, list),
        builder: (context, AsyncSnapshot<List<FlSpot>> snapshot) {
          if (!snapshot.hasData) {
            return AspectRatio(
                aspectRatio: 2.2,
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ));
          }
          return AspectRatio(
            aspectRatio: 2.2,
            child: LineChart(
              LineChartData(
                  gridData: FlGridData(
                    show: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                        spots: snapshot.data,
                        isCurved: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                        colors: [kPrimaryColor],
                        barWidth: 3),
                  ]),
            ),
          );
        });
  }
}

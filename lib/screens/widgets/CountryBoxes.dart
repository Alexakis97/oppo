import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oppo/functions/fetchcountry.dart';
import 'package:oppo/model/country.dart';
import 'package:oppo/model/countrycodes.dart';
import '../../constants.dart';
import 'info_card.dart';

class CountryScreen extends StatelessWidget {
  final Map country;

  const CountryScreen({Key key, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: FetchCountry.getNewCasesChart('${country['country']}'),
        builder: (context, AsyncSnapshot<List<Country>> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Flag(
                        CountryCodes.map[
                            "${(country['country'] as String).toLowerCase()}"],
                        height: 30,
                        width: 35,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          '${country['country']}, ${country['continent']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 40),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.03),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  child: Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      InfoCard(
                          title: "Total Cases",
                          iconColor: Color(0xFFFF8C00),
                          effectedNum: "${country['totalcases']}",
                          searchFor: "Total Cases",
                          countryMap: snapshot.data),
                      InfoCard(
                          title: "Total Deaths",
                          iconColor: Color(0xFFFF2D55),
                          effectedNum: "${country['totaldeaths']}",
                          searchFor: "Total Deaths",
                          countryMap: snapshot.data),
                      InfoCard(
                          title: "Recovered",
                          iconColor: Color(0xFF50E3C2),
                          effectedNum: "${country['recoveredcases']}",
                          searchFor: "Recovered",
                          countryMap: snapshot.data),
                      InfoCard(
                          title: "New Cases",
                          iconColor: Color(0xFF5886D6),
                          effectedNum: "${country['newcases']}",
                          searchFor: "New Cases",
                          countryMap: snapshot.data),
                      InfoCard(
                          title: "Critical   ",
                          iconColor: Colors.redAccent,
                          effectedNum: "${country['criticalcases']}",
                          searchFor: "Critical",
                          countryMap: snapshot.data),
                      InfoCard(
                          title: "New Deaths",
                          iconColor: Colors.red,
                          effectedNum: "${country['newdeaths']}",
                          searchFor: "New Deaths",
                          countryMap: snapshot.data),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor.withOpacity(.03),
      leading: IconButton(
          icon: SvgPicture.asset("assets/icons/menu.svg"), onPressed: () {}),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        )
      ],
    );
  }
}

class PreventionCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  const PreventionCard({
    Key key,
    this.svgSrc,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SvgPicture.asset(svgSrc),
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: kPrimaryColor),
      )
    ]);
  }
}

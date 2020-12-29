import 'dart:convert';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:oppo/functions/fetchcountry.dart';
import 'package:oppo/screens/info_screen.dart';
import 'package:oppo/screens/widgets/CountryBoxes.dart';
import 'package:oppo/screens/widgets/my_header.dart';
import '../blocs/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class PandemicLayout extends StatefulWidget {
  @override
  _PandemicLayout createState() => _PandemicLayout();
}

class _PandemicLayout extends State<PandemicLayout> {
  final _controller = TextEditingController();
  final controller = ScrollController();
  double offset = 0;
  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final bloc = Provider.of(context);
    bool focused = false;

    return ListView(
      children: [
        MyHeader(
          image: "assets/icons/Drcorona.svg",
          textTop: "All you need",
          textBottom: "is stay at home.",
          offset: offset,
        ),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: StreamBuilder(
                stream: bloc.getCountryStream,
                builder: (context, snapshot) {
                  focused = false;
                  return TextFormField(
                    onChanged: bloc.addCountryStream,
                    controller: _controller,
                    decoration: InputDecoration(
                        errorText: snapshot.error,
                        prefixIcon: Icon(Icons.flag_outlined),
                        hintText: 'Search Country',
                        labelText: 'Country',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _controller.clear();
                            bloc.addCountryStream('');
                          },
                          icon: Icon(Icons.clear),
                        )),
                  );
                })),
        StreamBuilder(
          stream: bloc.getCountryStream,
          builder: (context, AsyncSnapshot<String> snapshot) {
            print('${snapshot.connectionState}');
            if (snapshot.hasData) {
              final Map country = jsonDecode(snapshot.data);

              if (!focused) {
                FocusScope.of(context).unfocus();
                focused = true;
              }
              return Container(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        child: CountryScreen(
                          country: country,
                        )),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Statistics not found'));
            }
          },
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Symptoms",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        DynamicTheme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : kTitleTextColor),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SymptomCard(
                      image: "assets/images/headache.png",
                      title: "Headache",
                      isActive: true,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SymptomCard(
                      image: "assets/images/caugh.png",
                      title: "Caugh",
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SymptomCard(
                      image: "assets/images/fever.png",
                      title: "Fever",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Prevention",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        DynamicTheme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : kTitleTextColor),
              ),
              SizedBox(height: 20),
              PreventCard(
                text:
                    "Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                image: "assets/images/wear_mask.png",
                title: "Wear face mask",
              ),
              PreventCard(
                text:
                    "Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                image: "assets/images/wash_hands.png",
                title: "Wash your hands",
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: buildHelpCard(context)),
      ],
    );
  }

  Row buildPreventation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PreventionCard(
          svgSrc: "assets/icons/hand_wash.svg",
          title: "Wash Hands",
        ),
        PreventionCard(
          svgSrc: "assets/icons/use_mask.svg",
          title: "Use Mask",
        ),
        PreventionCard(
          svgSrc: "assets/icons/Clean_Disinfect.svg",
          title: "Clean Disinfect",
        ),
      ],
    );
  }

  Container buildHelpCard(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            padding: EdgeInsets.only(
                // left side padding is 40% of total width
                left: MediaQuery.of(context).size.width * .4,
                top: 20,
                right: 20),
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF60BE93), Color(0xFF1B8D59)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Dial 999 for \nMedical Help!\n",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                  TextSpan(
                    text: "If any symptoms appear",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SvgPicture.asset("assets/icons/nurse.svg"),
          ),
          Positioned(
            child: SvgPicture.asset("assets/icons/virus.svg"),
            top: 30,
            left: 10,
          ),
        ],
      ),
    );
  }
}

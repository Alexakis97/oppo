import 'dart:convert';
import 'package:flag/flag.dart';
import '../blocs/provider.dart';
import '../model/countrycodes.dart';
import 'package:flutter/material.dart';
import '../blocs/bloc.dart';

class PandemicLayout extends StatelessWidget {
  final _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final bloc = Provider.of(context);

    return ListView(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: StreamBuilder(
                stream: bloc.getCountryStream,
                builder: (context, snapshot) {
                  return TextFormField(
                    onChanged: bloc.addCountryStream,
                    controller: _controller,
                    decoration: InputDecoration(
                        errorText: snapshot.error,
                        icon: Icon(Icons.flag_outlined),
                        hintText: 'Search Country',
                        labelText: 'Country',
                        border: OutlineInputBorder(),
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
            if (snapshot.hasData) {
              final Map country = jsonDecode(snapshot.data);

              return Container(
                margin: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CountryLayout(
                        country: country,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text('');
            }
          },
        ),


      ],
    );
  }
}

class CountryLayout extends StatelessWidget {
  final Map country;

  CountryLayout({this.country});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Flag(
                  CountryCodes
                      .map["${(country['country'] as String).toLowerCase()}"],
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  'Population:',
                  style: TextStyle(fontSize: 18, ),
                )
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    '~${country['population']}',
                    style: TextStyle(fontSize: 18, ),
                  ))
            ],
          ),
          SizedBox(height: 30,),
          Text(
            'Today: ${country['day']}',
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16,fontWeight: FontWeight.bold),
          ),
          Card(
              child: Container(
                  margin:EdgeInsets.only(top:30,bottom: 30),child: Row(
                children: [
                  SizedBox(width: 40,),
                  Column(children: [
                    Text("New Cases", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 15,),
                    Text("${country['newcases']}",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange), )

                  ],),
                  SizedBox(width: 30,),
                  Column(children: [
                    Text("New Deaths",style: TextStyle(fontSize: 16)),
                    SizedBox(height: 15,),
                    Text("${country['newdeaths']}",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[800]), )

                  ],)

                ],
              ))),
          SizedBox(height: 30,),
          Card(
              child: Column(
                children: [

                  Container(

                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('Total Cases:',style: TextStyle(fontSize: 16)),),
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('${country['totalcases']}',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange), ),)
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('Total Recovered:',style: TextStyle(fontSize: 16)),),
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('${country['recoveredcases']}',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600]), ),)
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('Total Active:',style: TextStyle(fontSize: 16)),),
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('${country['activecases']}',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange), ),)
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('Total Deaths:',style: TextStyle(fontSize: 16)),),
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('${country['totaldeaths']}',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[800]), ),)
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('In Critical Condition:',style: TextStyle(fontSize: 16)),),
                        Container(margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text('${country['criticalcases']}',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.red), ),)
                      ],),

                    ],),)
                ],
              )),

        ],
      ),
    );
  }
}

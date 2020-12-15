import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oppo/model/country.dart';
import '../blocs/bloc.dart';


class PandemicLayout extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [
        Container(
          height: 25,
          width: 25,
          child: Image(image: AssetImage('assets/images/virus.png')),
        ),
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
                        hintText:
                            'Enter the country you would like to load info',
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: ()  {
                            _controller.clear();
                            bloc.addCountryStream('');
                          },
                          icon: Icon(Icons.clear),
                        )),
                  );
                })),
        StreamBuilder(
          stream: bloc.getCountryStream,
          builder: (context,AsyncSnapshot<String> snapshot){
            if(snapshot.hasData){

             final Country country = jsonDecode(snapshot.data);
              return Container(
                margin: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(' ${country.country}is found :)'),
                    ),
                  ],
                ),
              );
            }else{
              return Text('something went wrong');
            }
          },
        )
      ],
    );
  }
}

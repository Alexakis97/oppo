import 'package:flutter/material.dart';
import 'bloc.dart';

class Provider extends InheritedWidget{

  final Bloc bloc ;
  static Bloc of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;
  }
  Provider({Key key, Widget child})
      : bloc = Bloc(),
        super(key: key,child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
  
}
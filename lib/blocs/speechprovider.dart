import 'package:flutter/material.dart';
import 'blocspeech.dart';

class SpeechProvider extends InheritedWidget{

  final BlocSpeech bloc ;
  static BlocSpeech of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(SpeechProvider) as SpeechProvider).bloc;
  }
  SpeechProvider({Key key, Widget child})
      : bloc = BlocSpeech(),
        super(key: key,child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
  
}
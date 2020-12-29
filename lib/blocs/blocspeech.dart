import 'package:rxdart/rxdart.dart';
import '../resources/db_provider.dart';
import 'dart:async';
class BlocSpeech {

  final cache =  TaskDbProvider();

  final _wordController = BehaviorSubject<String>();



  Function(String) get addWordStream => _wordController.sink.add;

  Stream<String> get getWordStream=> _wordController.stream;





  dispose(){
    _wordController.close();
  }


}


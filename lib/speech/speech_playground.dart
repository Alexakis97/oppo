import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../blocs/speechprovider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import '../model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Speech extends StatefulWidget {
  @override
  _Speech createState() => _Speech();
}

class _Speech extends State<Speech> {
  bool hasSpeech = false;
  bool showpopup=false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String currentLocaleId = '';
  int resultListened = 0;
  String currentlang;
   List<LocaleName> localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();

    final future = getSharedPrefs();
    future.then((value) => {
      if(value==null){
        initSpeechState()
      }else{
        reloadSpeechState(value)
        
      }
    });
    
   


  }

   Future<String> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString("lang");
    
  }

  Future<void> reloadSpeechState(value) async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      localeNames = await speech.locales();
      currentLocaleId = value;
    }

    if (!mounted) return;

    setState(() {
      this.hasSpeech = hasSpeech;
    });
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      this.hasSpeech = hasSpeech;
    });
  }

  

  void startListening() {
    lastWords = '';
    lastError = '';
    showpopup=false;
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    showpopup=true;
    ++resultListened;
    print('Result listener $resultListened');
    setState(() {
      lastWords = '${result.recognizedWords}'; //- ${result.finalResult}
      print('sentence: ${lastWords}');

    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void switchLang(selectedVal) {
    
      currentLocaleId = selectedVal;
  
    print(selectedVal);
  }

  currectLanguage(countrycode)async{ 
      localeNames.forEach((element) {
        
        if(element.localeId==countrycode){
          
      
          setState(() {
            currentlang = element.name;
            
          });
         

        }
        
        });
        
  }
  
  @override
  Widget build(BuildContext context) {

    final speechbloc = SpeechProvider.of(context);
    final timetask = TextEditingController();
    final txt = TextEditingController();
    currectLanguage(currentLocaleId);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('title here')),
        body: Column(children: [

          Container(
            child: Column(
              children: <Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: <Widget>[
                //     FlatButton(
                //       child: Text('Initialize'),
                //       onPressed: hasSpeech ? null : initSpeechState,
                //     ),
                //   ],
                // ),
              //  Row(
               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
               //   children: <Widget>[
                    // FlatButton(
                    //   child: Text('Start'),
                    //   onPressed: !hasSpeech || speech.isListening
                    //       ? null
                    //       : startListening,
                    // ),
                    // FlatButton(
                    //   child: Text('Stop'),
                    //   onPressed: speech.isListening ? stopListening : null,
                    // ),
                    // FlatButton(
                    //   child: Text('Cancel'),
                    //   onPressed: speech.isListening ? cancelListening : null,
                    // ),
                  //],
               // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: <Widget>[
                //     DropdownButton(
                //       onChanged: (selectedVal) => switchLang(selectedVal),
                //       value: currentLocaleId,
                //       items: localeNames
                //           .map(
                //             (localeName) => DropdownMenuItem(
                //               value: localeName.localeId,
                //               child: Text(localeName.name),
                //             ),
                //           )
                //           .toList(),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Center(
                  child: 

                     Text(
                    '$currentlang',
                    style: TextStyle(fontSize: 22.0)
                  
                    
                  )
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        child: Center(
                          child: Builder( builder: (context){
                            print('$showpopup');

                            speechbloc.addWordStream(lastWords);

                            return StreamBuilder(
                              stream: speechbloc.getWordStream,
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  if(showpopup){
                                    if(snapshot.data!='') {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        print('${snapshot.data}');
                                        txt.text = "${snapshot.data}";

                                        // Add Your Code here.
                                        showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              // Use children total size
                                              children: [
                                                Text(
                                                  "Task Creator", style: TextStyle(fontSize: 22),),
                                                SizedBox(height: 10,),
                                                Container(width: 200, child: TextField(
                                                  controller: txt,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Task',
                                                  ),
                                                ),),

                                                SizedBox(height: 25,),
                                                Container(width: 200, child: BasicTimeField(
                                                  time: timetask,
                                                ),),

                                                TextButton(
                                                  child: const Text('Save'),
                                                  onPressed: () {
                                                    speechbloc.cache.addItem(Task(0,'${txt.text}','${timetask.text}',false));
                                                    Navigator.pop(context);
                                                    showpopup = false;
                                                  },
                                                ),
                                              ],),
                                          ),
                                        );
                                      });
                                    }
                                  }else{
                                   return Center(
                                      child: speech.isListening
                                          ? Container(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        color: Colors.green,
                                        child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "I'm listening...",
                                                  style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Icon(Icons.volume_up_sharp)
                                              ],
                                            )
                                        ),
                                      )
                                          : Container(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        color: Colors.yellow[600],
                                        child: Center(
                                            child:  Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Not listening...",
                                                  style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Icon(Icons.volume_off_sharp)
                                              ],
                                            )),
                                      ),
                                    );

                                  }
                                }
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  color: Colors.yellow[600],
                                  child: Center(
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Not listening...",
                                            style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Icon(Icons.volume_off_sharp)
                                        ],
                                      )),
                                );
                              },
                            );
                          },)
                        ),
                      ),
                      Positioned.fill(
                        bottom: 25,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: .26,
                                    spreadRadius: level * 2,
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: DynamicTheme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                  borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(right:4),

                              child: IconButton(
                              icon: Icon(Icons.mic,size: 35,
                              ),
                              onPressed: !hasSpeech || speech.isListening
                                  ? null
                                  : startListening,
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Expanded(
          //   flex: 1,
          //   child: Column(
          //     children: <Widget>[
          //       Center(
          //         child: Text(
          //           'Error Status',
          //           style: TextStyle(fontSize: 22.0),
          //         ),
          //       ),
          //       Center(
          //         child: Text(lastError),
          //       ),
          //     ],
          //   ),
          // ),
        ]));
  }

}


class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic date field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}

class BasicTimeField extends StatelessWidget {
  final TextEditingController time;
  BasicTimeField({this.time});
  final format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
     // Text('Basic time field (${format.pattern})'),
      DateTimeField(
        controller: time,
        decoration:  InputDecoration(
      border: OutlineInputBorder(),
    labelText: 'Time  ${format.pattern}',
    ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}

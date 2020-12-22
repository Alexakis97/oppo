import '../speech/speech_playground.dart';
import '../blocs/blocspeech.dart';
import '../model/task.dart';
import '../blocs/speechprovider.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Work extends StatefulWidget {
  @override
  _Work createState() => _Work();
}

class _Work extends State<Work> {
  final List<bool> _notify = <bool>[false,false,false,false,false,false];
  final task = TextEditingController();
  final timetask = TextEditingController();
  List<Task>allTasks;


  @override
  Widget build(BuildContext context) {
    final SpeechBloc = SpeechProvider.of(context);
    final future = SpeechBloc.cache.fetchTaskList();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm: \n EEE d MMM').format(now);

    return FutureBuilder(future: future, builder: (BuildContext context,  AsyncSnapshot<List<Task>>snapshot) {
      print('${snapshot.data}');
      if(!snapshot.hasData){
        return Text('loading');
      }

        if(snapshot.data.isEmpty){
          return Center(child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeechProvider(child: Speech())));},
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Click ",
                    ),
                    WidgetSpan(
                      child: Icon(Icons.mic, size: 18),
                    ),
                    TextSpan(
                      text: " to add a new task",
                    ),

                  ],
                ),
              )),);

      }
        allTasks=snapshot.data;
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: (allTasks.length),
            itemBuilder: (BuildContext context, int index) {
              return  Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: _taskWidget(index, SpeechBloc));
            });




    },);

  }

  Widget _taskWidget(index,BlocSpeech SpeechBloc) {
    return Card(
          child: Column(
            children: [
              ListTile(
                onTap: (){/*edit here*/
                  task.text="${allTasks[index].text}";
                  timetask.text="${allTasks[index].time}";
                  final format = DateFormat("HH:mm");
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        // Use children total size
                        children: [
                          Text(
                            "Task Editor", style: TextStyle(fontSize: 22),),
                          SizedBox(height: 10,),
                          Container(width: 200, child: TextField(
                            controller: task,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Task',
                            ),
                          ),),

                          SizedBox(height: 25,),
                          Container(width: 200, child:   Column(children: <Widget>[
                            // Text('Basic time field (${format.pattern})'),
                            DateTimeField(
                              controller: timetask,
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
                          ]),),

                          TextButton(
                            child: const Text('Save'),
                            onPressed: () {
                              SpeechBloc.cache.updateTask(Task(allTasks[index].id,task.text,timetask.text,allTasks[index].isExported));
                              setState(() {
                                allTasks[index].text=task.text;
                                allTasks[index].time=timetask.text;
                              });
                              Navigator.pop(context);

                            },
                          ),
                        ],),
                    ),
                  );
                },
                leading: Icon(Icons.access_time_outlined),
                trailing: TextButton(
                  child: Icon(
                    Icons.calendar_today,
                  ),
                  onPressed: () {},
                ),
                title: Text(
                  '${allTasks[index].text}',
                ),
                subtitle: Text('${allTasks[index].time}',
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
              SwitchListTile(
                title: const Text('Notify Me Earlier'),
                value: _notify[index],
                onChanged: (bool value) {
                  setState(() {
                    _notify[index] = value;
                  });
                },
                secondary: const Icon(Icons.lightbulb_outline),
              ),
              Center(

                child: IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    _showMyDialog(context,index,SpeechBloc);
                  },
                ),


              )
            ],
          ),
        );
  }
  Future<void> _showMyDialog(context,index,BlocSpeech SpeechBloc) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${allTasks[index].text} will be deleted'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                Text('Are you sure you would like to delete it?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                print("Deleting ID: ${allTasks[index].id}");
                SpeechBloc.cache.deleteTask(allTasks[index].id);
                setState(() {
                  allTasks.remove(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}



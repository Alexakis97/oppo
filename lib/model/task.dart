class Task{
  final int id;
  final String text;
  final String time;
  final bool isExported;

  Task(this.id, this.text, this.time, this.isExported);

  Task.fromDb(Map<String,dynamic> parsedJson): id = parsedJson['id'],text=parsedJson['text'],time=parsedJson['time'],isExported=parsedJson['isExported'] == 1;

  Map<String,dynamic> toMapForDb(){
    return <String,dynamic>{
      "text":text,
      "time":time,
      "isExported":isExported? 1: 0,
    };
  }

}
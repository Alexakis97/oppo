import 'dart:io';
import 'dart:async';
import '../model/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import  'package:path/path.dart';

class TaskDbProvider {
  Database db;
  var readyCompleter = Completer();
  Future get ready => readyCompleter.future;
  TaskDbProvider(){
    init().then((_) {
      // mark the provider ready when init completes
      readyCompleter.complete();
    });
  }

   Future init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'task1.db');
    db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database newDb, int version) {
          newDb.execute("""
          CREATE TABLE Task
          (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             text TEXT,
             time TEXT,
             isExported INTEGER
          )
        """);
        }
    );
  }

  Future<Task> fetchTask(int id) async{
    print('trying to get $id from cache');
    final maps = await db.query(
      "Task",
      columns: null,
      where:"id = ?",
      whereArgs: [id],
    );
    if(maps.length>0){
      print('$id found !! returning: ${maps.first}');
      return Task.fromDb(maps.first);
    }
    return null;
  }

  Stream<List<Task>> fetchTaskList() async*{
    await ready;
    List<Map<String,dynamic>> list = await db.query('Task');

    yield List.generate(list.length, (i) {
      return  Task.fromDb(list[i]);
    });
  }


  Future<int> addItem (Task task) {
    return db.insert("Task", task.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace //id already exists
    );
  }

  Future<void> updateTask(Task task) async {
    await db.update('Task', task.toMapForDb(),where:'id = ?',whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async{
    await db.delete('Task',where:'id = ?',whereArgs: [id]);
  }


  Future<int> clear(){
    return db.delete('Task');
  }

}
final taskDbProvider = TaskDbProvider();
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_todo/models/task.dart';
import 'package:path/path.dart';
import 'package:my_todo/models/date.dart';

class TodoDatabase {
//  TodoDatabase._privateConstructor();
//
//  static final TodoDatabase instance = TodoDatabase._privateConstructor();

  TodoDatabase() {
//    _initDatabase();
    print('this is ruuuuuuuuuuuuun');
  }

  static final TodoDatabase todoDatabase = TodoDatabase();

  Future<Database> _initDatabase() async {
    print('sup');
    var documentsDirectory = await getApplicationDocumentsDirectory();
    print('hey');
    print('the documentDirectory is ${documentsDirectory.path}');
    Database database = await openDatabase(
      join(documentsDirectory.path, 'todo_database.db'),
      onCreate: (Database db, int version) async {
        print(getDatabasesPath());
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS todo_table(
          task_date TEXT, task_name TEXT, is_checked BIT, priority TEXT, notes TEXT, category TEXT, alert TEXT, task_time TEXT)
          ''',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insert(Task task) async {
    final Database db = await _initDatabase();

//    await db.execute(
//      '''
//          CREATE TABLE IF NOT EXISTS todo_table(
//          task_date TEXT, task_name TEXT, is_checked BIT)
//          ''',
//    );

    await db.insert(
      'todo_table',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Task task) async {
    final Database db = await _initDatabase();

    if (!task.isChecked) {
      task.isChecked = true;
    } else {
      task.isChecked = false;
    }

    await db.update(
      'todo_table',
      task.toMap(),
      where: "task_name = ?",
      whereArgs: [task.taskTitle],
    );
  }

  Future<List<Task>> getTaskList(Date selectedDay) async {
    final Database db = await _initDatabase();

//    final List<Map<String, dynamic>> maps = await db.query('todo_table');
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM todo_table WHERE task_date=?',
        [selectedDay.toStringSQL()]);

    final List<Map<String, dynamic>> allMaps =
        await db.rawQuery('SELECT * FROM todo_table');

    print('-----------------------------------maps.length is ${maps.length}');

    print(
        '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ allMaps.length is ${allMaps.length}');

    return List.generate(maps.length, (int i) {
      return Task(
        date: maps[i]['task_date'],
        taskTitle: maps[i]['task_name'],
        isChecked: maps[i]['is_checked'] == 0 ? false : true,
        priority: maps[i]['priority'],
        notes: maps[i]['notes'],
        category: maps[i]['category'],
        alert: maps[i]['alert'],
        time: maps[i]['task_time'],
      );
    });
  }

  void dropTable() async {
    final Database db = await _initDatabase();
    await db.execute('DROP TABLE todo_table');
  }
}

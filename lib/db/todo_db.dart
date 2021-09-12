import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_todo/models/task.dart';
import 'package:path/path.dart';
import 'package:my_todo/models/date.dart';

class TodoDatabase {
//  TodoDatabase._privateConstructor();
//
//  static final TodoDatabase instance = TodoDatabase._privateConstructor();

//  TodoDatabase() {
////    _initDatabase();
//    print('database initialized');
//  }

//  final int version;
//
//  static final TodoDatabase todoDatabase = TodoDatabase();

  Future<Database> _initDatabase() async {
//    print('sup');
    var documentsDirectory = await getApplicationDocumentsDirectory();
//    print('hey');
//    print('the documentDirectory is ${documentsDirectory.path}');
    Database database = await openDatabase(
      join(documentsDirectory.path, 'todo_database.db'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
    return database;
  }

  void _onCreate(Database db, int version) async {
    // print(getDatabasesPath());
    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS todo_table(
          id INTEGER PRIMARY KEY, task_date TEXT, task_name TEXT, is_checked BIT, priority TEXT, notes TEXT, category TEXT, alert TEXT, task_time TEXT, has_time BIT, notification_id TEXT)
          ''',
    );
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
//      db.execute('ALTER TABLE todo_table ADD notification_id TEXT;');
    }
  }

  Future<void> insert(Task task) async {
    final Database db = await _initDatabase();

    await db.rawQuery(
        'INSERT INTO todo_table VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [
      task.date,
      task.taskTitle,
      !task.isChecked ? 0 : 1,
      task.priority,
      task.notes,
      task.category,
      task.alert,
      task.time,
      !task.hasTime ? 0 : 1,
      task.notificationId,
    ]);
  }

  Future<void> update(Task task) async {
    final Database db = await _initDatabase();

//    print(
//        'the tasks id in todo_db is ${task.id} and the tasks name is todo_db is ${task.taskTitle}');
//    print('and the tasks date is ${task.date}');
//    print('-----------the task is ${task.toMap()}');
    await db.update(
      'todo_table',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<List<Task>> getUncompletedTaskList() async {
    final Database db = await _initDatabase();

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * from todo_table WHERE is_checked=0');

//    print('there are ${maps.length} uncompleted tasks');

    return List.generate(maps.length, (int i) {
      // print('in listgenerate, the id is ${maps[i]['id']}');
      return Task(
        date: maps[i]['task_date'],
        taskTitle: maps[i]['task_name'],
        isChecked: maps[i]['is_checked'] == 0 ? false : true,
        priority: maps[i]['priority'],
        notes: maps[i]['notes'],
        category: maps[i]['category'],
        alert: maps[i]['alert'],
        time: maps[i]['task_time'],
        id: maps[i]['id'],
        hasTime: maps[i]['has_time'] == 0 ? false : true,
        notificationId: maps[i]['notification_id'],
      );
    });
  }

  Future<Task> getTaskById(int id) async {
    final Database db = await _initDatabase();

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM todo_table WHERE id=?', [id]);

    var tasks = List.generate(maps.length, (int i) {
      return Task(
        date: maps[i]['task_date'],
        taskTitle: maps[i]['task_name'],
        isChecked: maps[i]['is_checked'] == 0 ? false : true,
        priority: maps[i]['priority'],
        notes: maps[i]['notes'],
        category: maps[i]['category'],
        alert: maps[i]['alert'],
        time: maps[i]['task_time'],
        id: maps[i]['id'],
        hasTime: maps[i]['has_time'] == 0 ? false : true,
        notificationId: maps[i]['notification_id'],
      );
    });
    return tasks[0];
  }

  Future<List<Task>> getAllTaskList() async {
    final Database db = await _initDatabase();

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM todo_table');

    return List.generate(maps.length, (int i) {
//      print('in listgenerate, the id is ${maps[i]['id']}');
      return Task(
        date: maps[i]['task_date'],
        taskTitle: maps[i]['task_name'],
        isChecked: maps[i]['is_checked'] == 0 ? false : true,
        priority: maps[i]['priority'],
        notes: maps[i]['notes'],
        category: maps[i]['category'],
        alert: maps[i]['alert'],
        time: maps[i]['task_time'],
        id: maps[i]['id'],
        hasTime: maps[i]['has_time'] == 0 ? false : true,
        notificationId: maps[i]['notification_id'],
      );
    });
  }

  Future<List<Task>> getTasksByPriority(String priority) async {
    final Database db = await _initDatabase();

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM todo_table WHERE priority=?', [priority]);

    return List.generate(
      maps.length,
      (i) => Task(
        date: maps[i]['task_date'],
        taskTitle: maps[i]['task_name'],
        isChecked: maps[i]['is_checked'] == 0 ? false : true,
        priority: maps[i]['priority'],
        notes: maps[i]['notes'],
        category: maps[i]['category'],
        alert: maps[i]['alert'],
        time: maps[i]['task_time'],
        id: maps[i]['id'],
        hasTime: maps[i]['has_time'] == 0 ? false : true,
        notificationId: maps[i]['notification_id'],
      ),
    );
  }

  Future<List<Task>> getTasksByCategory(String category) async {
    final Database db = await _initDatabase();

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM todo_table WHERE category=?', [category]);

    return List.generate(
      maps.length,
      (i) => Task(
        date: maps[i]['task_date'],
        taskTitle: maps[i]['task_name'],
        isChecked: maps[i]['is_checked'] == 0 ? false : true,
        priority: maps[i]['priority'],
        notes: maps[i]['notes'],
        category: maps[i]['category'],
        alert: maps[i]['alert'],
        time: maps[i]['task_time'],
        id: maps[i]['id'],
        hasTime: maps[i]['has_time'] == 0 ? false : true,
        notificationId: maps[i]['notification_id'],
      ),
    );
  }

  Future<List<Task>> getTaskList(Date inputDay) async {
    final Database db = await _initDatabase();

//    final List<Map<String, dynamic>> maps = await db.query('todo_table');
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM todo_table WHERE task_date=?', [inputDay.toStringSQL()]);

    final List<Map<String, dynamic>> allMaps =
        await db.rawQuery('SELECT * FROM todo_table');
//
//    final List<Map<String, dynamic>> noDate =
//        await db.rawQuery('SELECT * FROM todo_table WHERE task_date is NULL');
//
//    final List<Map<String, dynamic>> uncompleted =
//        await db.rawQuery('SELECT * from todo_table WHERE is_checked=0');
//
//    print('the id in todo is ${maps[0]['id']}');
//
//    print('inputDay.toStringSQL is ${inputDay.toStringSQL()}');
//
//    print('-----------------------------------maps.length is ${maps.length}');
//
//    print(
//        '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ allMaps.length is ${allMaps.length}');
//
//    print('allMaps is \n');
//    for (var map in allMaps) {
//      print('$map\n');
//    }
//
//    print('noDate is \n');
//    for (var map in noDate) {
//      print('$map\n');
//    }
//
//    print('uncompleted tasks are \n');
//    for (var map in uncompleted) {
//      print('$map\n');
//    }

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
        id: maps[i]['id'],
        hasTime: maps[i]['has_time'] == 0 ? false : true,
        notificationId: maps[i]['notification_id'],
      );
    });
  }

  void dropTable() async {
    final Database db = await _initDatabase();
    await db.execute('DROP TABLE todo_table');
  }

  void deleteTask(Task task) async {
    final Database db = await _initDatabase();
    await db.execute('DELETE FROM todo_table where id = ?', [task.id]);
  }
}

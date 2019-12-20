import 'package:flutter/foundation.dart';
import 'task.dart';
import 'package:my_todo/db/todo_db.dart';
import 'date.dart';
import 'package:my_todo/screens/task_screen.dart';

class TaskData extends ChangeNotifier {
  final todoDB = TodoDatabase();

//  List<Map<String, dynamic>> maps = await todoDB.query()

//  List<Task> taskList;

  Future<List<Task>> getTaskList() async {
//    print(await todoDB.getTaskList());
    return await todoDB.getTaskList(TaskScreen.selectedDay);
  }

//  List<Task> taskList = [
//    Task(taskTitle: 'Go to the gym', isChecked: false),
//    Task(taskTitle: 'Finish Flutter course', isChecked: false),
//    Task(taskTitle: 'Learn ML', isChecked: false),
//    Task(taskTitle: 'Take out the trash', isChecked: false),
//  ];

  void updateTask(Task task) async {
    await todoDB.update(task);
    notifyListeners();
  }

  void addTask(String newTaskTitle, Date selectedDay) async {
//    taskList.add(Task(taskTitle: newTaskTitle, isChecked: false));
//    notifyListeners();
    await todoDB.insert(new Task(
      date: selectedDay.toStringSQL(),
      taskTitle: newTaskTitle,
      isChecked: false,
    ));
    notifyListeners();
  }

  void dropTable() {
    todoDB.deleteAll();
    notifyListeners();
  }

//  int get getCount {
//    return taskList.length;
//  }
//
//  int get getRemainingTasks {
//    int remaining = 0;
//    print(remaining);
//    for (var task in taskList) {
//      if (task.isChecked == false) {
//        remaining++;
//      }
//    }
//    return remaining;
//  }
}

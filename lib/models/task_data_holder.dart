import 'package:flutter/foundation.dart';
import 'task.dart';
import 'package:my_todo/db/todo_db.dart';
import 'date.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class TaskData extends ChangeNotifier {
  final todoDB = TodoDatabase();

//  List<Map<String, dynamic>> maps = await todoDB.query()

//  List<Task> taskList;

  Future<List<Task>> getTaskList(Date inputDay) async {
//    print(await todoDB.getTaskList());
    return await todoDB.getTaskList(inputDay);
  }

  Future<List<Task>> getUncompletedTaskList() async {
    return await todoDB.getUncompletedTaskList();
  }

  Future<List<Task>> getAllTaskList() async {
    return await todoDB.getAllTaskList();
  }

  Future<List<Task>> getTasksByPriority(String priority) async {
    return await todoDB.getTasksByPriority(priority);
  }

  Future<List<Task>> getTasksByCategory(String category) async {
    return await todoDB.getTasksByCategory(category);
  }

  Future<Task> getTaskById(int id) async {
    return await todoDB.getTaskById(id);
  }

//  List<Task> taskList = [
//    Task(taskTitle: 'Go to the gym', isChecked: false),
//    Task(taskTitle: 'Finish Flutter course', isChecked: false),
//    Task(taskTitle: 'Learn ML', isChecked: false),
//    Task(taskTitle: 'Take out the trash', isChecked: false),
//  ];

  Future<void> updateTask(Task task) async {
    print(
        'so updateTask has been called, and the task is: \n${task.toString()}');
    await todoDB.update(task);
    notifyListeners();
  }

  void addTask({
    String newTaskTitle,
    String taskDate,
    String priority,
    String notes,
    String category,
    String alert,
    String time,
    String notificationId,
  }) async {
//    taskList.add(Task(taskTitle: newTaskTitle, isChecked: false));
//    notifyListeners();

    await todoDB.insert(new Task(
      date: taskDate,
      taskTitle: newTaskTitle,
      isChecked: false,
      priority: priority,
      notes: notes,
      category: category,
      alert: alert,
      time: time,
      id: 0,
      hasTime: time == 'no time' ? false : true,
      notificationId: notificationId,
    ));

    notifyListeners();
  }

  void dropTable() {
    todoDB.dropTable();
    notifyListeners();
  }

  void deleteTask(task) {
    todoDB.deleteTask(task);
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

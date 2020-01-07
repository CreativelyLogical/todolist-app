import 'date.dart';

class Task {
  Task({
    this.taskTitle,
    this.isChecked,
    this.date,
    this.priority,
    this.notes,
    this.category,
    this.alert,
    this.time,
    this.id,
  });

  String taskTitle;
  bool isChecked;
  String date;
  String priority;
  String notes;
  String category;
  String alert;
  String time;
  int id;

  void toggleChecked() {
    isChecked = !isChecked;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_date': date,
      'task_name': taskTitle,
      'is_checked': !isChecked ? false : true,
      'priority': priority,
      'notes': notes,
      'category': category,
      'alert': alert,
      'task_time': time,
    };
  }
}

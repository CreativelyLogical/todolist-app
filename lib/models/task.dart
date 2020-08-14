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

  String toString() {
    return "id: ${this.id}\ntitle: ${this.taskTitle}\ncategory: ${this.category}\npriority: ${this.priority}";
  }

  void assimilateTask(final Task task) {
    task.id = this.id;
    task.date = this.date;
    task.taskTitle = this.taskTitle;
    task.isChecked = this.isChecked;
    task.priority = this.priority;
    task.notes = this.notes;
    task.category = this.category;
    task.alert = this.alert;
    task.time = this.time;
  }
}

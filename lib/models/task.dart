import 'date.dart';

class Task {
  Task({this.taskTitle, this.isChecked, this.date});

  String taskTitle;
  bool isChecked;
  String date;

  void toggleChecked() {
    isChecked = !isChecked;
  }

  Map<String, dynamic> toMap() {
    return {
      'task_date': date,
      'task_name': taskTitle,
      'is_checked': !isChecked ? false : true,
    };
  }
}

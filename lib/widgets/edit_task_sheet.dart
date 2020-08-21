import 'package:flutter/material.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/constants.dart';
import 'custom_flag_icon_icons.dart';
import 'package:my_todo/screens/task_category_icons.dart';
import 'priority_buttons.dart';
import 'package:my_todo/screens/set_time_icon_icons.dart';
import 'package:my_todo/screens/edit_screen_calendar_icons.dart';
import 'package:my_todo/models/date.dart';
import 'package:my_todo/screens/notification_bells_icons.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'duration_picker_dialog.dart';
import 'package:my_todo/widgets/horizontal_sized_box.dart';
import 'package:my_todo/widgets/category_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EditTaskSheet extends StatefulWidget {
  EditTaskSheet({this.task, this.dateChangedCallback});

  final Task task;

  final Function dateChangedCallback;

  @override
  _EditTaskSheetState createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  Task _task;

  String selectedPriority;

  String selectedDateSQL;

  String selectedTime;

  TimeOfDay selectedTimeOfDay;

  String selectedReminder;

  TextEditingController taskTitleController;

  bool taskHasTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTask();
  }

  void setTask() {
    _task = widget.task;
    selectedPriority = _task.priority;
    selectedDateSQL = _task.date;
    selectedTime = _task.time;
    selectedReminder = _task.alert;

    if (selectedTime == 'no time' || selectedTime == 'Set time') {
      print('task.name for this is ${_task.taskTitle}');
    } else {
      RegExp exp = new RegExp(r"(\d+)");
      Iterable<Match> matches = exp.allMatches(selectedTime);
      List<int> times = [];
      for (Match m in matches) {
        String match = m.group(0);
        times.add(int.parse(match));
      }
      selectedTimeOfDay = TimeOfDay(hour: times[0], minute: times[1]);
    }

    taskTitleController = TextEditingController(text: _task.taskTitle);
//    if (_task.time == 'no time') {
//      taskHasTime = false;
//    } else {
//      taskHasTime = true;
//    }
  }

  String selectedDate = Date(DateTime.now()).toString();
//  String selectedDateSQL = Date(DateTime.now()).toStringSQL();

  void getDateEditorOS(BuildContext context) {
    if (Platform.isIOS) {
      _selectDateCupertino(context);
    } else if (Platform.isAndroid) {
      print('platform is android');
    }
  }

  Widget _buildBottomSheet(Widget picker) {
    return Container(
      height: SizeConfig.screenHeight * 0.3,
      padding: EdgeInsets.only(top: 6.0),
      child: picker,
    );
  }

  Future<Null> _selectDateCupertino(BuildContext context) async {
    final DateTime picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => _buildBottomSheet(
        CupertinoDatePicker(
//        minimumDate: DateTime.now().add(Duration(days: -1)),
//        maximumDate: DateTime(2101),
          backgroundColor: Colors.white,
          minimumDate: DateTime.now().add(Duration(days: -1)),
          maximumDate: DateTime(2101),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
//              selectedDate = Date(newDate).toString();
              selectedDateSQL = Date(newDate).toStringSQL();
              _task.date = selectedDateSQL;
//              Provider.of<TaskData>(context).updateTask(_task);
            });
          },
        ),
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime:
          selectedTime == 'Set time' ? TimeOfDay.now() : selectedTimeOfDay,
    );
    if (picked.toString() != selectedTime && picked != null) {
      setState(() {
        selectedTimeOfDay = picked;
        selectedTime = selectedTimeOfDay.format(context);
        print('selectedTime is $selectedTime');
//        _task.time = selectedTime;
//        Provider.of<TaskData>(context).updateTask(_task);
      });
    }
  }

  void getTimePickerOS(context) {
    if (Platform.isAndroid) {
      _selectTime(context);
    } else if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => _buildBottomSheet(
          CupertinoDatePicker(
            backgroundColor: Colors.white,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime picked) {
              setState(() {
                selectedTimeOfDay = TimeOfDay.fromDateTime(picked);
                selectedTime = selectedTimeOfDay.format(context);
                _task.time = selectedTime;
              });
            },
          ),
        ),
      ).whenComplete(() => Provider.of<TaskData>(context).updateTask(_task));
    }
  }

  Color getCategoryColor(String category) {
    if (category == 'Personal') {
      return Colors.green;
    } else if (category == 'Work') {
      return Colors.blue;
    } else if (category == 'School') {
      return Colors.red;
    } else {
      // means category must be 'Business'
      return Colors.orange;
    }
  }

  String dateParser(String inputDate) {
    final Map<int, String> intToMonth = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    String year = inputDate.substring(0, 4);
    String month = inputDate.substring(5, 7);
    String date = inputDate.substring(8, 10);

    int intMonth = int.parse(month);
    int intDate = int.parse(date);
    assert(intMonth is int);
    assert(intDate is int);

    String letterMonth = intToMonth[intMonth];

    if (inputDate == Date(DateTime.now()).toStringSQL()) {
      return 'Today';
    } else if (inputDate ==
        Date(DateTime.now().add(Duration(days: 1))).toStringSQL()) {
      return 'Tomorrow';
    }
//    else if (inputDate ==
//        Date(DateTime.now().add(Duration(days: -1))).toStringSQL()) {
//      return 'Yesterday';
//    }

    return '$intDate $letterMonth $year';
  }

  @override
  Widget build(BuildContext context) {
    print('for the task ${_task.taskTitle}, task.HasTime is ${_task.hasTime}');
//    if (_task.time == 'no time') {
//      _task.hasTime = false;
//      Provider.of<TaskData>(context).updateTask(_task);
//    } else {
//      _task.hasTime = true;
//      Provider.of<TaskData>(context).updateTask(_task);
//    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomAppBar(
        color: kWhite,
        child: Container(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical,
            bottom: SizeConfig.blockSizeVertical,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EditTaskButton(
                icon: Icon(
                  Icons.highlight_off,
                  color: Colors.red,
                  size: SizeConfig.blockSizeVertical * 3.0,
                ),
                buttonText: 'Delete task',
                onPressed: () {
                  Provider.of<TaskData>(context).deleteTask(_task);
                  Navigator.pop(context);
                },
              ),
              EditTaskButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: kBlue,
                  size: SizeConfig.blockSizeVertical * 3.0,
                ),
                buttonText: 'Mark as done',
                onPressed: () {
                  print('mark as done button pressed');
                  if (_task.isChecked) {
                  } else {
                    _task.toggleChecked();
                    Provider.of<TaskData>(context).updateTask(_task);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.05),
              width: SizeConfig.screenWidth * 0.35,
              height: 8,
              decoration: BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * 0.05,
                right: SizeConfig.screenWidth * 0.05,
                bottom: SizeConfig.screenHeight * 0.03,
              ),
              child: TextFormField(
                controller: taskTitleController,
                style: TextStyle(
                  fontSize: 40.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * 0.05,
                bottom: SizeConfig.screenHeight * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    CustomFlagIcon.flag,
                    color: kBlue,
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'none',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'none';
                                _task.priority = selectedPriority;
                                Provider.of<TaskData>(context)
                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
//                          HorizontalSizedBox(
//                            boxWidth: SizeConfig.screenWidth * 0.08,
//                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'low',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'low';
                                _task.priority = selectedPriority;
                                Provider.of<TaskData>(context)
                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
//                          HorizontalSizedBox(
//                            boxWidth: SizeConfig.screenWidth * 0.08,
//                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'medium',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'medium';
                                _task.priority = selectedPriority;
                                Provider.of<TaskData>(context)
                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
//                          HorizontalSizedBox(
//                            boxWidth: SizeConfig.screenWidth * 0.08,
//                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'high',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'high';
                                _task.priority = selectedPriority;
                                Provider.of<TaskData>(context)
                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.screenHeight * 0.03,
                left: SizeConfig.screenWidth * 0.05,
              ),
              child: GestureDetector(
                onTap: () {
                  getDateEditorOS(context);
//                    setState(() {
//                      _task.date = selectedDateSQL;
////                        Provider.of<TaskData>(context).updateTask(_task);
//                    });
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      EditScreenCalendar.calendar,
                      color: kBlue,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.1,
                    ),
                    Text(
                      dateParser(selectedDateSQL),
                      style: TextStyle(
                        color: kBlue,
                        fontSize: SizeConfig.blockSizeVertical * 3.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.screenHeight * 0.03,
                left: SizeConfig.screenWidth * 0.05,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    TaskCategory.tag,
                    color: kBlue,
                  ),
                  HorizontalSizedBox(
                    boxWidth: SizeConfig.screenWidth * 0.1,
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Text(
                      _task.category,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: SizeConfig.blockSizeVertical * 3.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    color: getCategoryColor(_task.category),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CategoryDialog(
                          category: _task.category,
                          newCategoryCallback: (String newCategory) {
                            setState(() {
                              _task.category = newCategory;
                            });
                          },
                        ),
                      ).whenComplete(() =>
                          Provider.of<TaskData>(context).updateTask(_task));
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * 0.05,
                bottom: SizeConfig.screenHeight * 0.03,
                right: SizeConfig.screenWidth * 0.05,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (taskHasTime) {
                    getTimePickerOS(context);
                  }
                  print('time selector pressed');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          SetTimeIcon.clock,
                          color: kBlue,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.1,
                        ),
                        AutoSizeText(
//                          selectedTime == null ? _task.time : selectedTime,
                          selectedTime == 'no time' ? 'Set Time' : selectedTime,
                          style: TextStyle(
                            color: taskHasTime ? kBlue : Colors.grey.shade400,
                            decoration:
                                taskHasTime ? null : TextDecoration.lineThrough,
                            fontSize: SizeConfig.blockSizeVertical * 3.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      color: !taskHasTime ? kBlue : Colors.grey.shade300,
                      child: Text(
                        'No Time',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 3.0,
                          color: !taskHasTime ? kWhite : kGrey,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _task.toggleHasTime();
                          Provider.of<TaskData>(context).updateTask(_task);
//                          if (taskHasTime == true) {
//                            taskHasTime = false;
//                            Provider.of<TaskData>(context).updateTask(_task);
//                          } else {
//                            taskHasTime = true;
//                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * 0.05,
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => DurationPicker(
                      setReminderCallback: (reminder) {
                        selectedReminder = reminder;
                        setState(() {});
                        _task.alert = selectedReminder;
                      },
                    ),
                  );
                  print('reminder setter tapped');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      NotificationBells.bell,
                      color: kBlue,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.1,
                    ),
                    Text(
                      selectedReminder == 'no reminder'
                          ? 'No Reminder'
                          : selectedReminder,
                      style: TextStyle(
                        color: kBlue,
                        fontSize: SizeConfig.blockSizeVertical * 3.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskButton extends StatelessWidget {
  EditTaskButton({this.icon, this.buttonText, this.onPressed});

  final Icon icon;

  final String buttonText;

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          FittedBox(
            fit: BoxFit.fill,
            child: AutoSizeText(
              buttonText,
              style: TextStyle(
                color: buttonText == 'Delete task' ? Colors.red : kBlue,
                fontSize: SizeConfig.blockSizeVertical * 2.5,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

//class SaveChangesButton extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return RawMaterialButton(
//      fillColor: Colors.green,
//      shape: CircleBorder(),
//      padding: EdgeInsets.all(10.0),
//      child: Icon(
//        Icons.check,
//        color: Colors.white,
//        size: SizeConfig.blockSizeVertical * 4,
//      ),
//    );
//  }
//}

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
import 'package:my_todo/widgets/horizontal_sized_box.dart';
import 'package:my_todo/widgets/category_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_todo/notifications/todo_notifications.dart';
import 'delete_task_dialog.dart';

class EditTaskSheet extends StatefulWidget {
  EditTaskSheet({this.task, this.dateChangedCallback});

  final Task task;

  final Function dateChangedCallback;

  @override
  _EditTaskSheetState createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet>
    with SingleTickerProviderStateMixin {
  Task _task;

  String selectedPriority;

  String selectedDateSQL;

  String selectedTime;

  TimeOfDay selectedTimeOfDay;

  String selectedReminder;

  TextEditingController taskTitleController;

  AnimationController controller;

  bool taskHasTime;

  int notificationId;

  bool remind;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    controller.forward();

//    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());

    controller.addListener(() {
      setState(() {});
//      print(controller.value);
    });

    setTask();
  }

  void setTask() {
    _task = widget.task;
    selectedPriority = _task.priority;
    selectedDateSQL = _task.date;
    selectedTime = _task.time;
    selectedReminder = _task.alert;
    taskHasTime = _task.hasTime && _task.time != 'no time';
    notificationId = int.parse(_task.notificationId);

    remind = selectedReminder == 'yes reminder' ? true : false;

    if (taskHasTime) {
//      print('hello darkness my old friend');
      RegExp exp = new RegExp(r"(\d+)");
      Iterable<Match> matches = exp.allMatches(selectedTime);
      List<int> times = [];
      for (Match m in matches) {
        String match = m.group(0);
        times.add(int.parse(match));
      }
      RegExp morningOrAfternoon = new RegExp(r"([A-Z]+)");
      String time = morningOrAfternoon.firstMatch(selectedTime).group(0);
//      print('selectedTime in EditTaskSheet is $selectedTime');
//      print('time is $time');
      int hour = time == 'PM' ? times[0] + 12 : times[0];
      selectedTimeOfDay = TimeOfDay(hour: hour, minute: times[1]);
//      print('now selectedTimeOfDay is $selectedTimeOfDay');
    } else {
//      print('selectedTime in EditTaskSheet is $selectedTime');
    }
//    if (selectedTime == 'no time' || selectedTime == 'Set time') {
//      print('task.name for this is ${_task.taskTitle}');
//    } else {
//      RegExp exp = new RegExp(r"(\d+)");
//      Iterable<Match> matches = exp.allMatches(selectedTime);
//      List<int> times = [];
//      for (Match m in matches) {
//        String match = m.group(0);
//        times.add(int.parse(match));
//      }
//      RegExp morningOrAfternoon = new RegExp(r"([A-Z]+)");
//      String time = morningOrAfternoon.firstMatch(selectedTime).toString();
//      int hour = time == 'PM' ? times[0] + 12 : times[0];
//      selectedTimeOfDay = TimeOfDay(hour: hour, minute: times[1]);
//    }

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
      _selectDate(context);
    }
  }

  Widget _buildBottomSheet(Widget picker) {
    return Container(
      height: SizeConfig.screenHeight * 0.3,
      padding: EdgeInsets.only(top: 6.0),
      child: picker,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ).whenComplete(() async {
      TodoNotifications().cancelNotificationById(notificationId);

      if (remind) {
        DateTime notificationTimeOfDay = getNotificationDateTime();

        await TodoNotifications().schedule(
          notificationTitle: "Reminder",
          notificationBody: _task.taskTitle,
          notificationId: notificationId,
          dateTime: notificationTimeOfDay,
        );
      }
    });
    if (picked != null) {
      setState(() {
//        selectedDate = Date(picked).toString();
        selectedDateSQL = Date(picked).toStringSQL();
//        print('the selectedDate is $selectedDateSQL');
        _task.date = selectedDateSQL;
      });
    }
  }

  Future<Null> _selectDateCupertino(BuildContext context) async {
    final DateTime picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => _buildBottomSheet(
        CupertinoDatePicker(
//        minimumDate: DateTime.now().add(Duration(days: -1)),
//        maximumDate: DateTime(2101),
          backgroundColor: Colors.white,
          minimumDate: DateTime.now(),
          maximumDate: DateTime(2101),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
//              selectedDate = Date(newDate).toString();
              selectedDateSQL = Date(newDate).toStringSQL();
              _task.date = selectedDateSQL;
            });
          },
        ),
      ),
    ).whenComplete(() async {
      if (remind) {
        TodoNotifications().cancelNotificationById(notificationId);

        DateTime notificationTimeOfDay = getNotificationDateTime();

        await TodoNotifications().schedule(
          notificationTitle: "Reminder",
          notificationBody: _task.taskTitle,
          notificationId: notificationId,
          dateTime: notificationTimeOfDay,
        );
      }
      Provider.of<TaskData>(context).updateTask(_task);
    });
  }

  DateTime getNotificationDateTime() {
    Date selectedDate =
        Date(DateTime.now()).fromSQLToDate(date: selectedDateSQL);

    int year = selectedDate.year;
    int month = Date.monthToInt[selectedDate.month];
    int day = selectedDate.day;

//    print('selectedTimeOfDay in EditTaskSheet is $selectedTimeOfDay');

    return DateTime(
        year, month, day, selectedTimeOfDay.hour, selectedTimeOfDay.minute, 0);
  }

  Widget getSwitcherOS(BuildContext context) {
//    print('taskHasTime is $taskHasTime');
//    print('selectedTime is $selectedTime');
    if (Platform.isAndroid) {
      return Switch(
        value: remind,
        onChanged: (!taskHasTime || selectedTime == 'no time')
            ? null
            : (newValue) async {
                await TodoNotifications().init();
                setState(
                  () {
                    remind = newValue;
                    controller.value = 0;
                    controller.forward();
                  },
                );
                if (!remind) {
                  _task.alert = 'no reminder';
                  await TodoNotifications()
                      .cancelNotificationById(notificationId);
                } else if (remind) {
                  _task.alert = 'yes reminder';
                  DateTime notificationTimeOfDay = getNotificationDateTime();

                  await TodoNotifications().schedule(
                    notificationTitle: "Reminder",
                    notificationBody: _task.taskTitle,
                    notificationId: notificationId,
                    dateTime: notificationTimeOfDay,
                  );
                }
                Provider.of<TaskData>(context).updateTask(_task);
              },
      );
    } else if (Platform.isIOS) {
      return CupertinoSwitch(
        value: remind,
        onChanged: (!taskHasTime || selectedTime == 'no time')
            ? null
            : (newValue) async {
                await TodoNotifications().init();
                setState(
                  () {
                    remind = newValue;
                    controller.value = 0;
                    controller.forward();
                  },
                );
                if (!remind) {
//                  print('cancelling notifications');
                  _task.alert = 'no reminder';
                  await TodoNotifications()
                      .cancelNotificationById(notificationId);
                } else if (remind) {
//                  print('selectedTimeOfDay is $selectedTimeOfDay');
//                  print('notificationId is $notificationId');
                  _task.alert = 'yes reminder';
                  DateTime notificationTimeOfDay = getNotificationDateTime();
//                  print(
//                      'notificationTimeOfDay is ${notificationTimeOfDay.toString()}');
                  await TodoNotifications().schedule(
                      notificationTitle: "Reminder",
                      notificationBody: _task.taskTitle,
                      notificationId: notificationId,
                      dateTime: notificationTimeOfDay);
                }
                Provider.of<TaskData>(context).updateTask(_task);
              },
      );
    } else {
      return Container();
    }
  }

  DateTime getMinimumTime() {
    if (selectedDateSQL == Date(DateTime.now()).toStringSQL()) {
      return DateTime.now();
    } else {
      return null;
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime == 'no time'
          ? TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 5)))
          : selectedTimeOfDay,
    ).whenComplete(() async {
      Provider.of<TaskData>(context).updateTask(_task);
    });

    if (picked.toString() != selectedTime && picked != null) {
      setState(() async {
        selectedTimeOfDay = picked;
        int hour = picked.hourOfPeriod;
        if (hour == 0) {
          hour = 12;
        }
        String minute =
            picked.minute < 10 ? '0${picked.minute}' : '${picked.minute}';
        String period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        selectedTime = '$hour:$minute $period';
        _task.time = selectedTime;
//        print('selectedTime is $selectedTime');
//        _task.time = selectedTime;
//        Provider.of<TaskData>(context).updateTask(_task);
        await TodoNotifications().cancelNotificationById(notificationId);

        if (remind) {
          DateTime notificationTimeOfDay = getNotificationDateTime();

          await TodoNotifications().schedule(
            notificationTitle: "Reminder",
            notificationBody: _task.taskTitle,
            notificationId: notificationId,
            dateTime: notificationTimeOfDay,
          );
        }
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
            minimumDate: getMinimumTime(),
            initialDateTime: DateTime.now().add(Duration(minutes: 5)),
            onDateTimeChanged: (DateTime picked) {
              setState(() {
                selectedTimeOfDay = TimeOfDay.fromDateTime(picked);
                int hour = selectedTimeOfDay.hourOfPeriod;
                if (hour == 0) {
                  hour = 12;
                }
                String minute = picked.minute < 10
                    ? '0${picked.minute}'
                    : '${picked.minute}';
                String period =
                    selectedTimeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
                selectedTime = '$hour:$minute $period';
                _task.time = selectedTime;
              });
            },
          ),
        ),
      ).whenComplete(() async {
        if (remind) {
          TodoNotifications().cancelNotificationById(notificationId);

          DateTime notificationTimeOfDay = getNotificationDateTime();

          await TodoNotifications().schedule(
            notificationTitle: "Reminder",
            notificationBody: _task.taskTitle,
            notificationId: notificationId,
            dateTime: notificationTimeOfDay,
          );
        }
        Provider.of<TaskData>(context).updateTask(_task);
      });
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
//    print('for the task ${_task.taskTitle}, task.HasTime is ${_task.hasTime}');
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
                onPressed: () async {
                  String status = await showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteTaskDialog(
                      onDeleteTaskCallback: () {
//                        print('delete button pressed');
                        if (notificationId != null) {
                          TodoNotifications()
                              .cancelNotificationById(notificationId);
                        }
                      },
                    ),
                  );
                  if (status == 'deleted') {
                    Provider.of<TaskData>(context).deleteTask(_task);
                    Navigator.pop(context);
                  }
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
//                  print('mark as done button pressed');
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
                  fontSize: SizeConfig.blockSizeVertical * 3.5,
                ),
                onChanged: (newString) {
                  _task.taskTitle = newString;
                  Provider.of<TaskData>(context).updateTask(_task);
//                  print('task title is changed');
                },
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
                        fontWeight: FontWeight.w400,
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
                        fontWeight: FontWeight.w400,
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
//                  print('time selector pressed');
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
                            fontWeight: FontWeight.w400,
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
                        setState(() async {
                          _task.toggleHasTime();
                          taskHasTime = _task.hasTime;
                          if (!taskHasTime && notificationId != null) {
                            remind = false;
                            _task.alert = 'no reminder';
                            await TodoNotifications()
                                .cancelNotificationById(notificationId);
                          }
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
                right: SizeConfig.screenWidth * 0.05,
              ),
              child: GestureDetector(
                onTap: () {
//                  showDialog(
//                    context: context,
//                    builder: (BuildContext context) => DurationPicker(
//                      setReminderCallback: (reminder) {
//                        selectedReminder = reminder;
//                        setState(() {});
//                        _task.alert = selectedReminder;
//                      },
//                    ),
//                  );
//                  print('reminder setter tapped');
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
                      'Notify me',
                      style: TextStyle(
                        color: remind ? kBlue : Colors.grey.shade400,
                        fontSize: SizeConfig.blockSizeVertical * 3.0,
                        fontWeight: FontWeight.w400,
                        decoration: remind ? null : TextDecoration.lineThrough,
                      ),
                    ),
                    Spacer(),
                    getSwitcherOS(context),
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

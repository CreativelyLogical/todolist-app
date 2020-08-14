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
import 'package:fluttertoast/fluttertoast.dart';

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
//                Provider.of<TaskData>(context).updateTask(_task);
              });
            },
          ),
        ),
      );
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
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
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
                  initialValue: widget.task.taskTitle,
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
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'none',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'none';
                                _task.priority = selectedPriority;
//                                Provider.of<TaskData>(context)
//                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
                          HorizontalSizedBox(
                            boxWidth: SizeConfig.screenWidth * 0.08,
                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'low',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'low';
                                _task.priority = selectedPriority;
//                                Provider.of<TaskData>(context)
//                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
                          HorizontalSizedBox(
                            boxWidth: SizeConfig.screenWidth * 0.08,
                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'medium',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'medium';
                                _task.priority = selectedPriority;
//                                Provider.of<TaskData>(context)
//                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
                          HorizontalSizedBox(
                            boxWidth: SizeConfig.screenWidth * 0.08,
                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'high',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'high';
                                _task.priority = selectedPriority;
//                                Provider.of<TaskData>(context)
//                                    .updateTask(_task);
                              });
                            },
                            screen: 'edit_task',
                          ),
                        ],
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
                          fontSize: 25,
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
                          fontSize: 25,
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
//                                Provider.of<TaskData>(context)
//                                    .updateTask(_task);
                              });
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.05,
                  bottom: SizeConfig.screenHeight * 0.03,
                ),
                child: GestureDetector(
                  onTap: () {
                    getTimePickerOS(context);
                    print('time selector pressed');
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        SetTimeIcon.clock,
                        color: kBlue,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.1,
                      ),
                      Text(
//                          selectedTime == null ? _task.time : selectedTime,
                        selectedTime,
                        style: TextStyle(
                          color: kBlue,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      )
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
//                          Provider.of<TaskData>(context).updateTask(_task);
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
                        selectedReminder,
                        style: TextStyle(
                          color: kBlue,
                          fontSize: 25,
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
        SafeArea(
          bottom: false,
          minimum: EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment(0, 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Delete task',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                    ),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    print('delete button pressed');
                    Provider.of<TaskData>(context).deleteTask(_task);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    print('Save button pressed');
                    Provider.of<TaskData>(context).updateTask(_task);
                    Navigator.pop(context, 'complete');
                    Fluttertoast.showToast(
                        msg: "saved changes",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  fillColor: Colors.green,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: SizeConfig.blockSizeVertical * 4,
                  ),
                ),
                FlatButton(
                  child: Text(
                    'Mark as done',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                    ),
                  ),
                  color: kBlue,
                  onPressed: () {
                    print('done button pressed');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
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

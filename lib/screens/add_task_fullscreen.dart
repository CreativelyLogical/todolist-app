import 'package:flutter/material.dart';
import 'package:my_todo/widgets/day_container.dart';
import 'package:my_todo/widgets/week_view.dart';
import 'task_screen.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/models/date.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'custom_flag_icon_icons.dart';
import 'task_date_icons.dart';

class AddTaskFullScreen extends StatefulWidget {
  @override
  _AddTaskFullScreenState createState() => _AddTaskFullScreenState();
}

class _AddTaskFullScreenState extends State<AddTaskFullScreen> {
  List<DropdownMenuItem> prioritiesList = [
    DropdownMenuItem(
      child: Text(
        'None',
        style: TextStyle(
          color: kGrey,
          fontWeight: FontWeight.w800,
          fontSize: SizeConfig.blockSizeVertical * 3.5,
        ),
      ),
      value: 'None',
    ),
    DropdownMenuItem(
      child: Text(
        'Low',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w800,
          fontSize: SizeConfig.blockSizeVertical * 3.5,
        ),
      ),
      value: 'Low',
    ),
    DropdownMenuItem(
      child: Text(
        'Medium',
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w800,
          fontSize: SizeConfig.blockSizeVertical * 3.5,
        ),
      ),
      value: 'Medium',
    ),
    DropdownMenuItem(
      child: Text(
        'High',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w800,
          fontSize: SizeConfig.blockSizeVertical * 3.5,
        ),
      ),
      value: 'High',
    )
  ];

  String _selectedPriority = 'None';

  String addTaskDate = Date(DateTime.now()).toString();

  String addTaskDateSQL = Date(DateTime.now()).toStringSQL();

  TimeOfDay _timePicked = null;

  Future<TimeOfDay> selectedTime;

  bool isSwitched = false;

  String selectedPriority = 'none';

  TextEditingController taskNameController = TextEditingController();

  TextEditingController taskNotesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
//    Future<TimeOfDay> selectedTime = showTimePicker(
//      initialTime: TimeOfDay.now(),
//      context: context,
//    );

    print('now selectedPriority is $selectedPriority');

    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.close,
                    size: SizeConfig.blockSizeVertical *
                        SizeConfig.blockSizeHorizontal,
                    color: kGrey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              SizedBox(
                height: SizeConfig.screenHeight * 0.01,
              ),
//            WeekView(
//              setStateCallback: () {
//                setState(() {
//                  print(
//                      '----------------------- ${TaskScreen.selectedDay.toString()}');
//                });
//              },
//            ),
//            SizedBox(
//              height: SizeConfig.screenHeight * 0.05,
//            ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 4.3),
                child: TextFormField(
                  controller: taskNameController,
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 6),
                  decoration: InputDecoration(
                    hintText: 'eg. Read for 1 hour',
                    hintStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                    ),
                    labelText: "Task Name",
                    labelStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                    ),
//          fillColor: Colors.blue,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: kBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autofocus: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4.3,
                  vertical: SizeConfig.screenHeight * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
//                    Text(
//                      'Priority:   ',
//                      style: TextStyle(
//                        fontSize: SizeConfig.blockSizeVertical * 3.5,
//                        color: kGrey,
//                      ),
//                    ),
//                    Icon(
//                      CustomFlagIcon.flag,
//                      size: SizeConfig.blockSizeVertical * 3.3,
//                      color: Colors.grey.shade400,
//                    ),
                    Expanded(
                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'none',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'none';
                              });
                            },
                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'low',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'low';
                              });
                            },
                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'medium',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'medium';
                              });
                            },
                          ),
                          PriorityButtons(
                            selectedPriority: selectedPriority,
                            priority: 'high',
                            onTap: () {
                              setState(() {
                                selectedPriority = 'high';
                              });
                            },
                          ),
                        ],
                      ),
                    )
//                    DropdownButton(
//                      items: prioritiesList,
//                      value: _selectedPriority,
//                      onChanged: (priority) {
//                        setState(() {
//                          _selectedPriority = priority;
//                        });
//                      },
//                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 4.3,
                  top: SizeConfig.screenHeight * 0.01,
                  right: SizeConfig.blockSizeHorizontal * 4.3,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        color: addTaskDate == Date(DateTime.now()).toString()
                            ? kBlue
                            : Colors.grey.shade300,
                        child: Text(
                          'Today',
                          style: TextStyle(
                            color:
                                addTaskDate == Date(DateTime.now()).toString()
                                    ? kWhite
                                    : kGrey,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          print('today pressed');
                          setState(() {
                            addTaskDate = Date(DateTime.now()).toString();
                            addTaskDateSQL = Date(DateTime.now()).toStringSQL();
                          });
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.025,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                        color: Colors.grey.shade300,
                        child: Text(
                          'Tonight',
                          style: TextStyle(
                            color: kGrey,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          print('tonight pressed');
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.025,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        color: addTaskDate ==
                                Date(DateTime.now().add(Duration(days: 1)))
                                    .toString()
                            ? kBlue
                            : Colors.grey.shade300,
                        child: Text(
                          'Tomorrow',
                          style: TextStyle(
                            fontSize: 20,
                            color: addTaskDate ==
                                    Date(DateTime.now().add(Duration(days: 1)))
                                        .toString()
                                ? kWhite
                                : kGrey,
                          ),
                        ),
                        onPressed: () {
                          print('tomorrow pressed');
                          setState(() {
                            addTaskDate =
                                Date(DateTime.now().add(Duration(days: 1)))
                                    .toString();
                            addTaskDateSQL =
                                Date(DateTime.now().add(Duration(days: 1)))
                                    .toStringSQL();
                          });
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.025,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 4.3,
                  top: SizeConfig.screenHeight * 0.01,
                  right: SizeConfig.blockSizeHorizontal * 4.3,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        color: Colors.grey.shade300,
                        child: Text(
                          'Next Week',
                          style: TextStyle(
                            color: kGrey,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          print('next week pressed pressed');
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.025,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                        color: Colors.grey.shade300,
                        child: Text(
                          'Custom',
                          style: TextStyle(
                            color: kGrey,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          print('Custom pressed');
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.025,
                      ),
//                      FlatButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        ),
//                        color: Colors.grey.shade300,
//                        child: Text(
//                          'Tomorrow',
//                          style: TextStyle(
//                            fontSize: 20,
//                            color: addTaskDate ==
//                                    Date(DateTime.now().add(Duration(days: 1)))
//                                        .toString()
//                                ? kWhite
//                                : kGrey,
//                          ),
//                        ),
//                        onPressed: () {
//                          print('tomorrow pressed');
//                          setState(() {
//                            addTaskDate =
//                                Date(DateTime.now().add(Duration(days: 1)))
//                                    .toString();
//                            addTaskDateSQL =
//                                Date(DateTime.now().add(Duration(days: 1)))
//                                    .toStringSQL();
//                          });
//                        },
//                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.025,
                      ),
                    ],
                  ),
                ),
              ),
//              Padding(
//                padding: EdgeInsets.only(
//                  left: SizeConfig.blockSizeHorizontal * 4.3,
//                  top: SizeConfig.blockSizeVertical * 1.5,
//                ),
//                child: SizedBox(
//                  height: SizeConfig.screenHeight * 0.05,
//                  child: ListView(
//                    scrollDirection: Axis.horizontal,
//                    children: <Widget>[
//                      FlatButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        ),
//                        color: addTaskDate == Date(DateTime.now()).toString()
//                            ? kBlue
//                            : Colors.grey.shade300,
//                        child: Text(
//                          'Today',
//                          style: TextStyle(
//                            fontSize: SizeConfig.blockSizeVertical * 2.5,
//                            color:
//                                addTaskDate == Date(DateTime.now()).toString()
//                                    ? kWhite
//                                    : kGrey,
//                          ),
//                        ),
//                        onPressed: () {
//                          print('today pressed');
//                          setState(() {
//                            addTaskDate = Date(DateTime.now()).toString();
//                            addTaskDateSQL = Date(DateTime.now()).toStringSQL();
//                          });
//                        },
//                      ),
//                      SizedBox(
//                        width: SizeConfig.blockSizeHorizontal * 4.3,
//                      ),
//                      FlatButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        ),
//                        color: addTaskDate ==
//                                Date(DateTime.now().add(Duration(days: 1)))
//                                    .toString()
//                            ? kBlue
//                            : Colors.grey.shade300,
//                        child: Text(
//                          'Tomorrow',
//                          style: TextStyle(
//                            fontSize: SizeConfig.blockSizeVertical * 2.5,
//                            color: addTaskDate ==
//                                    Date(DateTime.now().add(Duration(days: 1)))
//                                        .toString()
//                                ? kWhite
//                                : kGrey,
//                          ),
//                        ),
//                        onPressed: () {
//                          print('tomorrow pressed');
//                          setState(() {
//                            addTaskDate =
//                                Date(DateTime.now().add(Duration(days: 1)))
//                                    .toString();
//                            addTaskDateSQL =
//                                Date(DateTime.now().add(Duration(days: 1)))
//                                    .toStringSQL();
//                          });
//                        },
//                      ),
//                      SizedBox(
//                        width: SizeConfig.blockSizeHorizontal * 4.3,
//                      ),
//                      FlatButton.icon(
//                        color: Colors.grey.shade300,
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        ),
//                        onPressed: () {
//                          print('custom pressed');
//                        },
//                        icon: Icon(
//                          Icons.date_range,
//                          color: Colors.grey.shade700,
//                        ),
//                        label: Text(
//                          'Custom',
//                          style: TextStyle(
//                            fontSize: SizeConfig.blockSizeVertical * 2.5,
//                            color: Colors.grey.shade700,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            Padding(
//              padding: EdgeInsets.symmetric(
//                horizontal: SizeConfig.blockSizeHorizontal * 4.3,
//                vertical: SizeConfig.blockSizeVertical * 2.5,
//              ),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
//                  TaskScreen.selectedDay.dateCompare(new Date(DateTime.now()))
//                      ? Text(
//                          'Today or ',
//                          style: TextStyle(
//                            fontSize: SizeConfig.blockSizeVertical * 4,
//                            color: kGrey,
//                          ),
//                        )
//                      : Text(
//                          '${TaskScreen.selectedDay.toString()} or ',
//                          style: TextStyle(
//                            fontSize: SizeConfig.blockSizeVertical * 4,
//                            color: kGrey,
//                          ),
//                        ),
//                  CircleAvatar(
//                    backgroundColor: kBlue,
//                    radius: SizeConfig.blockSizeVertical * 3.5,
//                    child: IconButton(
//                      icon: Icon(
//                        Icons.date_range,
//                        color: kWhite,
//                      ),
//                      iconSize: SizeConfig.blockSizeVertical * 4,
//                      onPressed: () {
//                        showDatePicker(
//                            context: context,
//                            initialDate: DateTime.now(),
//                            firstDate: DateTime(1970),
//                            lastDate: DateTime(2100));
//                      },
//                    ),
//                  ),
//                ],
//              ),
//            ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 2.5,
                  left: SizeConfig.blockSizeHorizontal * 4.3,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Time: ',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 3.5,
                        color: kGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4.3,
                ),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      color: _timePicked == null ? kBlue : Colors.grey.shade300,
                      child: Text(
                        'No Time',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.5,
                          color: _timePicked == null ? kWhite : kGrey,
                        ),
                      ),
                      onPressed: () {
                        print('time is set');
                        setState(() {
                          _timePicked = null;
                        });
                      },
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 4.3,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      color: Colors.grey.shade300,
                      child: Text(
                        'Set Time',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      onPressed: () {
                        print('time is set');
                        setState(() {
                          selectedTime = showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                        });
                        print(selectedTime);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 4.3,
                  top: SizeConfig.blockSizeVertical * 1,
                  bottom: SizeConfig.blockSizeVertical * 0,
                  right: SizeConfig.blockSizeHorizontal * 4.3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Remind me:',
                      style: TextStyle(
                        color: kGrey,
                        fontSize: SizeConfig.blockSizeVertical * 3.5,
                      ),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (newValue) {
                        setState(() {
                          isSwitched = newValue;
                        });
                      },
                      activeColor: kBlue,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 4.3,
                    vertical: SizeConfig.blockSizeVertical * 2.5),
                child: TextField(
                  controller: taskNotesController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Tap here to add notes',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kBlue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.3,
                    vertical: 5,
                  ),
                  color: kBlue,
                  onPressed: () {
                    print('add button pressed');
//                    Provider.of<TaskData>(context).dropTable();
                    print(
                        'the taskNameController.text was ${taskNameController.text}');
                    print(
                        '************************* the addTaskDate was $addTaskDate');
                    print(
                        'aaaaaaaaaaaaaaaaaaand, the selectedPriority was $selectedPriority');
                    Provider.of<TaskData>(context).addTask(
                      taskNameController.text,
                      addTaskDateSQL,
                      selectedPriority,
                      taskNotesController.text.length == 0
                          ? 'no notes'
                          : taskNotesController.text,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 3.5,
                      color: kWhite,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//class CustomTextField extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.symmetric(
//          horizontal: SizeConfig.blockSizeHorizontal * 4.3),
//      child: TextFormField(
//        controller: _AddTaskFullScreenState.taskNameController,
//        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 6),
//        decoration: InputDecoration(
//          hintText: 'eg. Read for 1 hour',
//          hintStyle: TextStyle(
//            fontSize: SizeConfig.blockSizeHorizontal * 4.5,
//          ),
//          labelText: "Task Name",
//          labelStyle: TextStyle(
//            fontSize: SizeConfig.blockSizeHorizontal * 6,
//          ),
////          fillColor: Colors.blue,
//          border: OutlineInputBorder(
//            borderSide: const BorderSide(color: kBlue, width: 2.0),
//            borderRadius: BorderRadius.circular(10.0),
//          ),
//        ),
//        autofocus: true,
//      ),
//    );
//  }
//}

class PriorityButtons extends StatelessWidget {
  PriorityButtons({this.selectedPriority, this.priority, this.onTap});

  final String priority;

  final String selectedPriority;

  final Function onTap;

  Color getPriorityColor() {
    if (priority == 'none')
      return Colors.grey.shade500;
    else if (priority == 'low')
      return Colors.green;
    else if (priority == 'medium')
      return Colors.orange;
    else if (priority == 'high') return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: SizeConfig.screenWidth * 0.08),
        child: CircleAvatar(
          backgroundColor: getPriorityColor(),
          radius: SizeConfig.blockSizeVertical * 2.0,
          child: Icon(
            CustomFlagIcon.flag,
            color:
                selectedPriority == priority ? kWhite : kWhite.withOpacity(0),
            size: SizeConfig.blockSizeVertical * 2.5,
          ),
        ),
      ),
    );
  }
}

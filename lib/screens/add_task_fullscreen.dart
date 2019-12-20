import 'package:flutter/material.dart';
import 'package:my_todo/widgets/day_container.dart';
import 'package:my_todo/widgets/week_view.dart';
import 'task_screen.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/models/date.dart';

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

  TimeOfDay _timePicked = null;

  Future<TimeOfDay> selectedTime;

  bool isSwitched = false;

  String selectedPriority = 'none';

  @override
  Widget build(BuildContext context) {
//    Future<TimeOfDay> selectedTime = showTimePicker(
//      initialTime: TimeOfDay.now(),
//      context: context,
//    );

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
              CustomTextField(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4.3,
                  vertical: SizeConfig.screenHeight * 0.01,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Priority:   ',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 3.5,
                        color: kGrey,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                ),
                child: Text(
                  'Date:  $addTaskDate',
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical * 3.5,
                    color: kGrey,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 4.3,
                    top: SizeConfig.blockSizeVertical * 1.5,
                  ),
                  child: SizedBox(
                    height: SizeConfig.screenHeight * 0.05,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          color: addTaskDate == Date(DateTime.now()).toString()
                              ? kBlue
                              : Colors.grey.shade300,
                          child: Text(
                            'Today',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2.5,
                              color:
                                  addTaskDate == Date(DateTime.now()).toString()
                                      ? kWhite
                                      : kGrey,
                            ),
                          ),
                          onPressed: () {
                            print('today pressed');
                            setState(() {
                              addTaskDate = Date(DateTime.now()).toString();
                            });
                          },
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 4.3,
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          color: addTaskDate ==
                                  Date(DateTime.now().add(Duration(days: 1)))
                                      .toString()
                              ? kBlue
                              : Colors.grey.shade300,
                          child: Text(
                            'Tomorrow',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2.5,
                              color: addTaskDate ==
                                      Date(DateTime.now()
                                              .add(Duration(days: 1)))
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
                            });
                          },
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 4.3,
                        ),
                        FlatButton.icon(
                          color: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          onPressed: () {
                            print('custom pressed');
                          },
                          icon: Icon(
                            Icons.date_range,
                            color: Colors.grey.shade700,
                          ),
                          label: Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2.5,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
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
                      'Remind me about this:',
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
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
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

class CustomTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 4.3),
      child: TextFormField(
        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 6),
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
    );
  }
}

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
      child: CircleAvatar(
        backgroundColor: getPriorityColor(),
        radius: SizeConfig.blockSizeVertical * 2.5,
        child: Icon(
          Icons.check,
          color: selectedPriority == priority ? kWhite : kWhite.withOpacity(0),
          size: SizeConfig.blockSizeVertical * 3.5,
        ),
      ),
    );
  }
}

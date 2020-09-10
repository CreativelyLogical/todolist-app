import 'package:flutter/material.dart';
import 'task_screen.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/models/date.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'set_time_icon_icons.dart';
import 'package:my_todo/widgets/priority_buttons.dart';
import 'notification_bells_icons.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:my_todo/notifications/todo_notifications.dart';

class AddTaskFullScreen extends StatefulWidget {
  final String screen;

  AddTaskFullScreen({@required this.screen});
  @override
  _AddTaskFullScreenState createState() => _AddTaskFullScreenState();
}

class _AddTaskFullScreenState extends State<AddTaskFullScreen>
    with SingleTickerProviderStateMixin {
//  List<DropdownMenuItem> categoriesList = [
//    DropdownMenuItem(
//      child: Text(
//        'Personal',
//        style: TextStyle(
//          fontSize: SizeConfig.blockSizeVertical * 3,
//          color: kGrey,
//        ),
//      ),
//      value: 'Personal',
//    ),
//    DropdownMenuItem(
//      child: Text(
//        'Work',
//        style: TextStyle(
//          fontSize: SizeConfig.blockSizeVertical * 3,
//          color: kGrey,
//        ),
//      ),
//      value: 'Work',
//    ),
//    DropdownMenuItem(
//      child: Text(
//        'School',
//        style: TextStyle(
//          fontSize: SizeConfig.blockSizeVertical * 3,
//          color: kGrey,
//        ),
//      ),
//      value: 'School',
//    ),
//    DropdownMenuItem(
//      child: Text(
//        'Business',
//        style: TextStyle(
//          fontSize: SizeConfig.blockSizeVertical * 3,
//          color: kGrey,
//        ),
//      ),
//      value: 'Business',
//    ),
//  ];

  AnimationController controller;

  String _selectedPriority = 'None';

  String addTaskDate = Date(DateTime.now()).toString();

  String addTaskDateSQL = Date(DateTime.now()).toStringSQL();

  TimeOfDay _timePicked = null;

  String selectedTime = 'Set time';

  TimeOfDay selectedTimeOfDay;

  bool isSwitched = false;

  String selectedPriority = 'none';

  Date selectedDateObject = TaskScreen.selectedDay;

  static String selectedCategory = 'Personal';

  TextEditingController taskNameController = TextEditingController();

  TextEditingController taskNotesController = TextEditingController();

  String selectedReminder;

//  String selectedDate = Date(DateTime.now()).toString();
  String selectedDate = TaskScreen.selectedDay.toString();

  String selectedTag = 'Today';

//  String selectedDateSQL = Date(DateTime.now()).toStringSQL();
  String selectedDateSQL = TaskScreen.selectedDay.toStringSQL();

  bool taskHasTime = true;

  bool remind = false;

  bool cannotSetReminder = false;

  bool attemptToSetReminderWhenCannot = false;

  final _containerKey = GlobalKey<_AddTaskFullScreenState>();

  final _categoryKey = GlobalKey();

  final _textfieldKey = GlobalKey();

  Color getSelectedTagColor(String tag) {
    return selectedTag == tag ? kBlue : Colors.grey.shade300;
  }

  Color getSelectedTagTextColor(String tag) {
    return selectedTag == tag ? kWhite : kGrey;
  }

  String getAppropriateDate() {
    if (selectedTag == 'Today' ||
        selectedTag == 'Tomorrow' ||
        selectedTag == 'Next Week') {
      return addTaskDateSQL;
    } else if (selectedTag == 'Custom') {
      return selectedDateSQL;
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
      firstDate: DateTime.now().add(Duration(days: 0)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDateObject = Date(picked);
        selectedDate = Date(picked).toString();
        selectedDateSQL = Date(picked).toStringSQL();
      });
    }
  }

  Future<void> _selectDateCupertino(BuildContext context) async {
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
              selectedDate = Date(newDate).toString();
              print('selectedDate now is $selectedDate');
              selectedDateSQL = Date(newDate).toStringSQL();
            });
          },
        ),
      ),
    );
  }

  void getDatePickerOS(BuildContext context) {
    print('the context sent to getDatePickerOS is ${context.toString()}');
    if (Platform.isAndroid) {
      _selectDate(context);
    } else if (Platform.isIOS) {
      _selectDateCupertino(context);
    }
  }

  DateTime getMinimumTime() {
    if (selectedDateSQL == Date(DateTime.now()).toStringSQL()) {
      return DateTime.now();
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.screen == 'AllTasksScreen') {
      selectedDate = Date(DateTime.now()).toString();
    }

    cannotSetReminder = !taskHasTime || (selectedTime == 'Set time');

    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    controller.forward();

//    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());

    controller.addListener(() {
      setState(() {});
      print(controller.value);
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime == 'Set time'
          ? TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 5)))
          : selectedTimeOfDay,
    );
    if (picked.toString() != selectedTime && picked != null) {
      print('picked is $picked');
      setState(() {
        // Check if the user entered time is in the future or has already passed
        selectedTimeOfDay = picked;
        int hour = picked.hourOfPeriod;
        if (hour == 0) {
          hour = 12;
        }
        String minute =
            picked.minute < 10 ? '0${picked.minute}' : '${picked.minute}';
        String period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        selectedTime = '$hour:$minute $period';

//        selectedTime = selectedTimeOfDay.format(context);
//        print('whereas selectedTime is $selectedTime');
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
            mode: CupertinoDatePickerMode.time,
            backgroundColor: Colors.white,
            minimumDate: getMinimumTime(),
            initialDateTime: DateTime.now().add(Duration(minutes: 5)),
            onDateTimeChanged: (DateTime picked) {
              setState(() {
                selectedTimeOfDay = TimeOfDay.fromDateTime(picked);
                int hour = picked.hour > 12 ? picked.hour - 12 : picked.hour;
                String minute = picked.minute < 10
                    ? '0${picked.minute}'
                    : '${picked.minute}';
                String period =
                    selectedTimeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
                selectedTime = '$hour:$minute $period';
              });
              print(selectedTime);
            },
          ),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
//    getSizeAndPosition();
  }

  void getSizeAndPosition() {
    final State currentState = _textfieldKey.currentState;

    final BuildContext currentContext = _textfieldKey.currentContext;

    final RenderBox _containerBox = currentState.context.findRenderObject();

    Size containerSize = _containerBox.size;
    Offset containerPosition = _containerBox.localToGlobal(Offset.zero);

    print('come on $containerSize $containerPosition');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  Widget getSwitcherOS(BuildContext context) {
    cannotSetReminder = !taskHasTime || (selectedTime == 'Set time');
    print('taskHasTime is $taskHasTime');
    print('cannotSetReminder is $cannotSetReminder');
    print('selectedTime is $selectedTime');
    if (Platform.isAndroid) {
      return Switch(
        value: remind,
        onChanged: (newValue) async {
          if (cannotSetReminder) {
            setState(() {
              attemptToSetReminderWhenCannot = true;
            });
          } else {
            attemptToSetReminderWhenCannot = false;
            await TodoNotifications().init();
            setState(() {
              remind = newValue;
              controller.value = 0;
              controller.forward();
            });
          }
        },
      );
    } else if (Platform.isIOS) {
      return CupertinoSwitch(
        value: remind,
        onChanged: (newValue) async {
          if (cannotSetReminder) {
            setState(() {
              attemptToSetReminderWhenCannot = true;
            });
          } else {
            attemptToSetReminderWhenCannot = false;
            await TodoNotifications().init();
            setState(() {
              remind = newValue;
              controller.value = 0;
              controller.forward();
            });
          }
        },
      );
    } else {
      return Container();
    }
  }

  Widget notificationMsg() {
    if (cannotSetReminder && attemptToSetReminderWhenCannot) {
      return Text(
        'Please set a time first',
        style: TextStyle(
          fontSize: SizeConfig.blockSizeVertical * 2.5,
          color: Colors.red,
        ),
      );
    } else if (remind) {
      return Padding(
        padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical * 1.5),
        child: Text(
          'Notify me',
          style: TextStyle(
            fontSize: SizeConfig.blockSizeVertical * 2.5,
            color: Colors.blue.shade800,
          ),
        ),
      );
    }
//    return Text(
//      (cannotSetReminder && attemptToSetReminderWhenCannot)
//          ? 'Please set a time first'
//          : 'Notify me',
//      style: TextStyle(
//        fontSize: SizeConfig.blockSizeVertical * 2.5,
//        color: (cannotSetReminder && attemptToSetReminderWhenCannot)
//            ? Colors.red
//            : Colors.blue.shade800,
//      ),
//    );
  }

  DateTime getNotificationDateTime() {
    Date selectedDate =
        Date(DateTime.now()).fromSQLToDate(date: selectedDateSQL);

    int year = selectedDate.year;
    int month = Date.monthToInt[selectedDate.month];
    int day = selectedDate.day;

    print('selectedTimeOfDay in AddTaskFullScreen is $selectedTimeOfDay');

    return DateTime(
        year, month, day, selectedTimeOfDay.hour, selectedTimeOfDay.minute, 0);
  }

  @override
  Widget build(BuildContext context) {
//    Future<TimeOfDay> selectedTime = showTimePicker(
//      initialTime: TimeOfDay.now(),
//      context: context,
//    );

//    print('now selectedPriority is $selectedPriority');
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: kBlue,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.screenHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4.3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: SizeConfig.blockSizeVertical *
                                SizeConfig.blockSizeHorizontal,
                            color: kWhite,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.03,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
//            SizedBox(
//              height: SizeConfig.screenHeight * 0.01,
//            ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 4.3,
                  bottom: SizeConfig.screenHeight * 0.01,
                ),
                child: Text(
                  'Add new task',
                  style: TextStyle(
                    color: kWhite,
                    fontSize: SizeConfig.blockSizeVertical * 4.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4.3,
                ),
                child: TextFormField(
                  controller: taskNameController,
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 6,
                    color: kWhite,
                  ),
                  decoration: InputDecoration(
                    hintText: 'eg. Read for 1 hour',
                    hintStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                      color: kWhite,
                    ),
                    labelText: "Task Name",
                    labelStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                      color: kWhite,
                    ),
//          fillColor: Colors.blue,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kWhite, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kWhite, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autofocus: false,
                  cursorColor: kWhite,
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
              Expanded(
                child: Container(
                  height: SizeConfig.screenHeight * 0.7,
                  key: _containerKey,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                  child: ListView(
//                shrinkWrap: false,
//                crossAxisAlignment: CrossAxisAlignment.start,
                    padding: EdgeInsets.only(top: 5),
                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.only(
//                          left: SizeConfig.blockSizeHorizontal * 4.3,
//                          top: SizeConfig.screenHeight * 0.02,
//                        ),
//                        child: Text(
//                          'Priority',
//                          style: TextStyle(
//                            fontSize: SizeConfig.blockSizeVertical * 2.5,
//                            color: Colors.grey.shade500,
//                          ),
//                        ),
//                      ), // priority
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                PriorityButtons(
                                  selectedPriority: selectedPriority,
                                  priority: 'none',
                                  onTap: () {
                                    setState(() {
                                      selectedPriority = 'none';
                                    });
                                  },
                                  screen: 'add_task',
                                ),
                                Text(
                                  'none',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                PriorityButtons(
                                  selectedPriority: selectedPriority,
                                  priority: 'low',
                                  onTap: () {
                                    setState(() {
                                      selectedPriority = 'low';
                                    });
                                  },
                                  screen: 'add_task',
                                ),
                                Text(
                                  'low',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                PriorityButtons(
                                  selectedPriority: selectedPriority,
                                  priority: 'medium',
                                  onTap: () {
                                    setState(() {
                                      selectedPriority = 'medium';
                                    });
                                  },
                                  screen: 'add_task',
                                ),
                                Text(
                                  'medium',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                PriorityButtons(
                                  selectedPriority: selectedPriority,
                                  priority: 'high',
                                  onTap: () {
                                    setState(() {
                                      selectedPriority = 'high';
                                    });
                                  },
                                  screen: 'add_task',
                                ),
                                Text(
                                  'high',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ), // priority buttons
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4.3,
                          top: SizeConfig.screenHeight * 0.02,
                        ),
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.5,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ), // date
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4.3,
                          top: 1,
                          right: SizeConfig.blockSizeHorizontal * 4.3,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            getDatePickerOS(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                selectedDate,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 3.5,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  getDatePickerOS(context);
                                },
                                child: Icon(
                                  Icons.date_range,
                                  size: SizeConfig.blockSizeVertical * 4,
                                  color: kGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // date setter
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 4.3),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ), // divider
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4.3,
                          top: SizeConfig.screenHeight * 0.02,
                        ),
                        child: Text(
                          'Time',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.5,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ), // time
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4.3,
                          right: SizeConfig.blockSizeHorizontal * 4.3,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
//                              await _selectTime(context);
                                if (taskHasTime) {
                                  getTimePickerOS(context);
//                                  setState(() {});
                                }
//                                getTimePickerOS(context);
//                                setState(() {
//                                  if (selectedTime != 'Set time') {
//                                    timeOption = true;
//                                  }
//                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    selectedTime,
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 3.5,
                                      color: taskHasTime
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade400,
                                      decoration: taskHasTime
                                          ? null
                                          : TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.03,
                                  ),
                                  Align(
                                    alignment: Alignment(0, 1),
                                    child: Icon(
                                      SetTimeIcon.clock,
                                      size: SizeConfig.blockSizeVertical * 4,
                                      color: taskHasTime
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment(0, -1),
                              child: FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                color:
                                    !taskHasTime ? kBlue : Colors.grey.shade300,
                                child: Text(
                                  'No Time',
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical * 3,
                                    color: !taskHasTime ? kWhite : kGrey,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (taskHasTime == true) {
                                      taskHasTime = false;
                                      remind = false;
                                    } else
                                      taskHasTime = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ), // time setter
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 4.3),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ), // divider
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4.3,
                          right: SizeConfig.blockSizeHorizontal * 4.3,
                          top: SizeConfig.screenHeight * 0.03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: remind == true
                                        ? Colors.blue.shade100
                                        : Colors.grey.shade300,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if (!remind) {
                                            print(
                                                'cant set alert, option deactivated');
                                          }
                                        },
                                        child: Icon(
                                          remind == true
                                              ? NotificationBells.bell
                                              : NotificationBells
                                                  .bell_off_empty,
                                          size:
                                              SizeConfig.blockSizeVertical * 3,
                                          color: remind == true
                                              ? Colors.blue.shade800
                                                  .withOpacity(controller.value)
                                              : Colors.grey.shade600
                                                  .withOpacity(
                                                      controller.value),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.02),
                                  child: notificationMsg(),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.02,
                                ),
//                              Text(
//                                'Remind me',
//                                style: TextStyle(
//                                  fontSize: SizeConfig.blockSizeVertical * 3,
//                                ),
//                              ),
                              ],
                            ),
                            getSwitcherOS(context),
//                          Switch(
//                            value: remind,
//                            onChanged: (value) {
//                              setState(() {
//                                controller.value = 0;
//                                controller.forward();
//                                remind = value;
//                              });
//                            },
//                          )
                          ],
                        ),
                      ), // reminder
                      Padding(
                        key: _categoryKey,
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4.3,
                          top: SizeConfig.screenHeight * 0.02,
                        ),
                        child: Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ), // time
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4.3,
                          right: SizeConfig.blockSizeHorizontal * 4.3,
                          top: SizeConfig.screenHeight * 0.02,
                          bottom: SizeConfig.screenHeight * 0.02,
                        ),
                        child: Container(
                          height: SizeConfig.screenHeight * 0.05,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              CategoryTag(
                                categoryName: 'Personal',
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = 'Personal';
                                  });
                                },
                              ),
                              CategoryTag(
                                categoryName: 'Work',
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = 'Work';
                                  });
                                },
                              ),
                              CategoryTag(
                                categoryName: 'School',
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = 'School';
                                  });
                                },
                              ),
                              CategoryTag(
                                categoryName: 'Business',
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = 'Business';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.1,
                          right: SizeConfig.screenWidth * 0.1,
                          top: SizeConfig.screenHeight * 0.01,
                          bottom: SizeConfig.screenHeight * 0.03,
                        ),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Add task',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: SizeConfig.blockSizeHorizontal * 6,
                            ),
                          ),
                          color: kBlue,
                          onPressed: () async {
                            int notificationId =
                                (DateTime.now().millisecondsSinceEpoch / 1000)
                                    .floor();
                            if (taskNameController.text == '') {
                              print('Please enter a task name');
                            } else {
                              Provider.of<TaskData>(context).addTask(
                                newTaskTitle: taskNameController.text,
                                taskDate: selectedDateSQL,
                                priority: selectedPriority,
                                notes: 'no notes',
                                category: selectedCategory,
                                alert: remind == true
                                    ? "yes reminder"
                                    : 'no reminder',
                                time:
                                    (!taskHasTime || selectedTime == 'Set time')
                                        ? 'no time'
                                        : selectedTime,
//                                time: taskHasTime == true
//                                    ? (selectedTime == 'Set time'
//                                        ? 'no time'
//                                        : selectedTime)
//                                    : 'no time',
                                notificationId: notificationId.toString(),
                              );
                              print(selectedTimeOfDay);
                              if (!taskHasTime || selectedTime == 'Set time') {
                              } else {
                                print('remind is $remind');
                                if (remind) {
                                  DateTime notificationTime =
                                      getNotificationDateTime();
                                  await TodoNotifications().schedule(
                                      notificationTitle: 'Reminder',
                                      notificationBody: taskNameController.text,
                                      notificationId: notificationId,
                                      dateTime: notificationTime);
                                }
                              }
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
//
            ],
          ),
        )
//      body:
        );
  }
}

class CategoryTag extends StatelessWidget {
  CategoryTag({this.categoryName, this.onPressed});

  final String categoryName;
  final Function onPressed;

  MaterialColor color;

  void getCategory() {
    if (categoryName == 'Personal') {
      color = Colors.green;
    } else if (categoryName == 'Work') {
      color = Colors.blue;
    } else if (categoryName == 'School') {
      color = Colors.red;
    } else if (categoryName == 'Business') {
      color = Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    getCategory();
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth * 0.01,
      ),
      child: FlatButton(
        child: Text(
          categoryName,
          style: TextStyle(
            fontFamily: 'Nunito',
            color: _AddTaskFullScreenState.selectedCategory == categoryName
                ? kWhite
                : color.shade900,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        color: _AddTaskFullScreenState.selectedCategory == categoryName
            ? color
            : color.shade300.withOpacity(0.6),
        onPressed: onPressed,
      ),
    );
  }
}

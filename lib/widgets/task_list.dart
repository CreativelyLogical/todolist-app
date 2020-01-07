import 'package:flutter/material.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/size_config.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/screens/add_task_fullscreen.dart';
import 'package:my_todo/screens/task_screen.dart';
import 'custom_flag_icon_icons.dart';
import 'notes_indicator_icons.dart';
import 'package:my_todo/screens/task_category_icons.dart';
import 'package:my_todo/screens/notification_bell_icons.dart';
import 'priority_buttons.dart';
import 'package:my_todo/screens/set_time_icon_icons.dart';
import 'package:my_todo/screens/edit_screen_calendar_icons.dart';
import 'package:my_todo/models/date.dart';
import 'package:my_todo/screens/notification_bells_icons.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'duration_picker_dialog.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    List<Task> tasks = Provider.of<TaskData>(context).taskList;
//    return ListView.builder(
//      itemBuilder: (BuildContext context, int index) {
//        return ListTile(
//          text: Provider.of<TaskData>(context).taskList[index],
//        );
//      },
//      itemCount: Provider.of<TaskData>(context).taskList.length,
//    );

//    List<Task> taskList = [
//      Task(taskTitle: 'to the gym', isChecked: false),
//      Task(taskTitle: 'take out the trash', isChecked: false),
//      Task(taskTitle: 'task 3', isChecked: false),
//    ];

//    () async {
//      taskList = await Provider.of<TaskData>(context).getTaskList();
////      for (var task in taskList) print(task.taskTitle);
//    }();

//    print('right now the length of taskList is ${taskList.length}');

    Future<List<Task>> getTaskList() async {
//      print('**********************');
      List<Task> taskList = await Provider.of<TaskData>(context)
          .getTaskList(TaskScreen.selectedDay);
      print('********************** taskList.length is ${taskList.length}');
      return await Provider.of<TaskData>(context)
          .getTaskList(TaskScreen.selectedDay);
    }

    print('did it even reach here?');
    return FutureBuilder<List<Task>>(
//      initialData: Container(
//        child: Center(
//          child: Text('waiting for completion'),
//        ),
//      ),
      initialData: [Task(taskTitle: 'nothing', isChecked: false)],
      future: getTaskList(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  height: SizeConfig.screenHeight * 0.080,
                ),
                Container(
//                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
//                border: Border.all(color: kBlue, width: 2),
                      ),
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.screenHeight * 0.01,
                    horizontal: SizeConfig.screenWidth * 0.03,
                  ),
                  height: SizeConfig.screenHeight * 0.081,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Tasks: ',
                        style: TextStyle(
                          color: kBlue,
                          fontSize: SizeConfig.screenHeight * 0.035,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_box,
                          size: SizeConfig.screenHeight * 0.045,
                          color: kBlue,
                        ),
                        iconSize: SizeConfig.screenHeight * 0.05,
                        onPressed: () {
                          print('add icon pressed');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddTaskFullScreen()));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
//            SizedBox(
//              height: SizeConfig.screenHeight * 0.01,
//            ),
            Expanded(
              child: snapshot.data == null
                  ? Container(
                      child: Center(
                        child: Text(
                          'snapshot was null',
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(top: 10.0),
                      itemBuilder: (BuildContext context, int index) {
                        final task = snapshot.data[index];
                        print('so the title is ${task.taskTitle}');
                        print('the task id in taskList is ${task.id}');
                        print('the task is checked? ${task.isChecked}');
                        return TaskListTile(
                          taskName: task.taskTitle,
                          isChecked: task.isChecked,
                          checkBoxCallback: () {
                            if (!task.isChecked) {
                              task.isChecked = true;
                            } else {
                              task.isChecked = false;
                            }
                            Provider.of<TaskData>(context).updateTask(task);
                          },
                          priority: task.priority,
                          notes: task.notes,
                          category: task.category,
                          alert: task.alert,
                          time: task.time,
                          task: task,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        height: SizeConfig.screenHeight * 0.01,
                        color: Color.fromRGBO(234, 234, 234, 1),
                      ),
                      itemCount: snapshot.data.length,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class TaskListTile extends StatefulWidget {
  TaskListTile({
    this.taskName,
    this.priority,
    this.notes,
    this.category,
    this.time,
    this.checkBoxCallback,
    this.isChecked,
    this.alert,
    this.task,
  });

  final String taskName;

  final String priority;

  final String notes;

  final String category;

  final String time;

  final Function checkBoxCallback;

  final bool isChecked;

  final String alert;

  final Task task;

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  Color returnPriorityColor() {
    print('in listview, priority is ${widget.priority}');
    if (widget.priority == 'none')
      return Colors.grey.shade500;
    else if (widget.priority == 'low')
      return Colors.green;
    else if (widget.priority == 'medium')
      return Colors.orange;
    else
      return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task.isChecked == true) {
      print('wtf is going on here');
    }
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: SizeConfig.screenHeight * 0.75,
            child: EditTaskSheet(
              task: widget.task,
//              dateChangedCallback: (String newSelectedDate) {
//                setState(() {
//                  widget.task.date = newSelectedDate;
//                  Provider.of<TaskData>(context).updateTask(widget.task);
//                });
//              },
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          isScrollControlled: true,
        );
      },
      child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth * 0.03,
          ),
          padding: EdgeInsets.only(
            left: SizeConfig.screenWidth * 0.05,
            right: SizeConfig.screenWidth * 0.05,
            top: SizeConfig.screenHeight * 0.005,
            bottom: SizeConfig.screenHeight * 0.005,
          ),
          decoration: BoxDecoration(
//          color: Colors.grey.shade200,
//          border: Border.all(color: kBlue, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: kWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
//          color: Colors.grey[200],
          ),
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: widget.checkBoxCallback,
                  child: Container(
//              constraints: BoxConstraints.expand(),
//              height: SizeConfig.screenHeight,
//              height: 60,
                    alignment: Alignment.centerLeft,
                    child: CircleCheckBox(
                      icon: widget.isChecked
                          ? Icon(
                              Icons.check,
                              color: kBlue,
                              size: SizeConfig.blockSizeVertical * 4,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.taskName,
//                        softWrap: true,
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                          color: widget.isChecked ? Colors.grey : kBlue,
                          fontWeight: FontWeight.w500,
                          decoration: widget.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 0.4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.screenHeight * 0.003),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  CustomFlagIcon.flag,
                                  color: returnPriorityColor(),
                                  size: SizeConfig.blockSizeVertical * 2.5,
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.01,
                                ),
                                widget.notes == 'no notes'
                                    ? Container()
                                    : Icon(
                                        NotesIndicator.doc_text,
                                        color: kBlue,
                                        size:
                                            SizeConfig.blockSizeVertical * 2.5,
                                      ),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.blockSizeHorizontal * 1.8,
                                      vertical:
                                          SizeConfig.blockSizeVertical * 0.5),
                                  decoration: BoxDecoration(
//                                  border: Border.all(color: kBlue, width: 1),
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade500,
                                        blurRadius: 1.5,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        TaskCategory.tag,
                                        size: SizeConfig.blockSizeVertical * 2,
                                        color: kBlue,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth * 0.01,
                                      ),
                                      Text(
                                        widget.category == null
                                            ? 'none'
                                            : widget.category,
                                        style: TextStyle(
                                          color: kBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // category
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.02,
                                ),
                                widget.alert == 'no reminder'
                                    ? Container()
                                    : Icon(
                                        NotificationBells.bell,
                                        color: kBlue,
                                        size:
                                            SizeConfig.blockSizeVertical * 2.5,
                                      )
                              ],
                            ),
                          ),
//                      Spacer(),
                          (widget.time == 'no time' || widget.time == null)
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.blockSizeHorizontal * 1.5),
                                  decoration: BoxDecoration(
//                                  border: Border.all(color: kBlue, width: 1),
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1.5,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    widget.time,
                                    style: TextStyle(
                                      color: kBlue,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

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
          minimumDate: DateTime.now().add(Duration(days: -1)),
          maximumDate: DateTime(2101),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
//              selectedDate = Date(newDate).toString();
              selectedDateSQL = Date(newDate).toStringSQL();
              _task.date = selectedDateSQL;
              Provider.of<TaskData>(context).updateTask(_task);
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
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime picked) {
              setState(() {
                selectedTimeOfDay = TimeOfDay.fromDateTime(picked);
                selectedTime = selectedTimeOfDay.format(context);
                _task.time = selectedTime;
                Provider.of<TaskData>(context).updateTask(_task);
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

    return '$intDate $letterMonth $year';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.05),
            child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                Container(
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
//                    left: SizeConfig.screenWidth * 0.05,
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
//                    left: SizeConfig.screenWidth * 0.05,
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
                                  Provider.of<TaskData>(context)
                                      .updateTask(_task);
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
                                  Provider.of<TaskData>(context)
                                      .updateTask(_task);
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
                                  Provider.of<TaskData>(context)
                                      .updateTask(_task);
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
                                  Provider.of<TaskData>(context)
                                      .updateTask(_task);
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
                  ),
                  child: GestureDetector(
                    onTap: () {
                      getDateEditorOS(context);
                      setState(() {
//                        _task.date = selectedDateSQL;
//                        Provider.of<TaskData>(context).updateTask(_task);
                      });
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
                                  Provider.of<TaskData>(context)
                                      .updateTask(_task);
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
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => DurationPicker(
                        setReminderCallback: (reminder) {
                          selectedReminder = reminder;
                          setState(() {});
                          _task.alert = selectedReminder;
                          Provider.of<TaskData>(context).updateTask(_task);
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
//                Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
////            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Align(
//                      alignment: Alignment.centerLeft,
//                      child: DateButton(),
//                    ),
//                    Align(
//                      alignment: Alignment.centerRight,
//                      child: Container(
//                        margin: EdgeInsets.only(
//                          top: SizeConfig.screenHeight * 0.03,
//                          left: SizeConfig.screenWidth * 0.05,
//                        ),
//                        padding: EdgeInsets.symmetric(
//                          horizontal: SizeConfig.blockSizeHorizontal * 4,
//                          vertical: SizeConfig.blockSizeVertical * 1,
//                        ),
//                        decoration: BoxDecoration(
//                            color: kBlue,
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(40.0),
//                            )),
//                        child: Row(
//                          children: <Widget>[
//                            Icon(
//                              SetTimeIcon.clock,
//                              color: kWhite,
//                              size: SizeConfig.blockSizeVertical * 5.5,
//                            ),
//                            SizedBox(
//                              width: SizeConfig.blockSizeHorizontal * 2,
//                            ),
//                            Text(
//                              (_task.time == null || _task.time == 'no time')
//                                  ? 'Set time'
//                                  : _task.time,
//                              style: TextStyle(
//                                color: kWhite,
//                                fontSize: 18,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 0.95),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Delete Task',
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
        )
      ],
    );
  }
}

class CategoryDialog extends StatelessWidget {
  CategoryDialog({this.category, this.newCategoryCallback});

  final String category;

  final Function newCategoryCallback;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        width: SizeConfig.screenWidth * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(0, 2),
                    color: Colors.grey.shade300,
                  )
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
              ),
              padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * 0.05,
                top: SizeConfig.screenHeight * 0.02,
                bottom: SizeConfig.screenHeight * 0.02,
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.04,
                  ),
                  Text(
                    'Select category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.screenHeight * 0.01,
              ),
              child:
                  CategorySelection('Personal', category, newCategoryCallback),
            ),
            Divider(
              thickness: 0.5,
            ),
            CategorySelection('Work', category, newCategoryCallback),
            Divider(
              thickness: 0.5,
            ),
            CategorySelection('School', category, newCategoryCallback),
            Divider(
              thickness: 0.5,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.01),
              child:
                  CategorySelection('Business', category, newCategoryCallback),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySelection extends StatelessWidget {
  CategorySelection(this.selection, this.currentCategory, this.callback);

  final String selection;

  final String currentCategory;

  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth * 0.05,
        vertical: SizeConfig.screenHeight * 0.01,
      ),
      child: InkWell(
        onTap: () {
          print('$selection pressed');
          callback(selection);
          Navigator.pop(context);
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                selection,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Spacer(),
              selection == currentCategory
                  ? Icon(
                      Icons.check,
                      color: kBlue,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalSizedBox extends StatelessWidget {
  HorizontalSizedBox({this.boxWidth});

  final double boxWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxWidth,
    );
  }
}

class CircleCheckBox extends StatelessWidget {
  CircleCheckBox({this.icon});

  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
//      radius: SizeConfig.blockSizeVertical * 2.4,
      decoration: BoxDecoration(
        color: icon == null
            ? Colors.grey.shade400
            : kLightBlueAccent.withOpacity(0.0),
        shape: BoxShape.circle,
        boxShadow: icon == null
            ? [
                BoxShadow(
                  color: Colors.grey.shade600,
                  blurRadius: 0.8,
                )
              ]
            : null,
      ),
      child: CircleAvatar(
        radius: SizeConfig.blockSizeVertical * 2.3,
        backgroundColor: icon == null
            ? Colors.grey.shade200
            : kLightBlueAccent.withOpacity(0.0),
        child: icon,
      ),
    );
  }
}

class DateButton extends StatefulWidget {
  @override
  _DateButtonState createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
//      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: SizeConfig.screenHeight * 0.03,
        left: SizeConfig.screenWidth * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 4,
        vertical: SizeConfig.blockSizeVertical * 1,
      ),
      decoration: BoxDecoration(
        color: kBlue,
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: SizeConfig.blockSizeVertical * 5.5,
                    color: kWhite,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateTime.now().day.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: kWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 2,
          ),
          Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              color: kWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class DraggableBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DraggableScrollableSheet'),
      ),
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                child: Center(
                  child: Text(
                    'Hello world',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

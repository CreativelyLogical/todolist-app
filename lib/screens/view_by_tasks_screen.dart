import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'task_category_icons.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:my_todo/widgets/edit_task_sheet.dart';
import 'package:my_todo/models/task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'add_task_fullscreen.dart';
import 'package:my_todo/notifications/todo_notifications.dart';

class ViewByTasksScreen extends StatefulWidget {
  final String direction;
  final String detail;

  ViewByTasksScreen({
    @required this.direction,
    @required this.detail,
  });

  @override
  _ViewByTasksScreenState createState() => _ViewByTasksScreenState();
}

class _ViewByTasksScreenState extends State<ViewByTasksScreen> {
  List<Task> taskList;

  Future _getTasksList() async {
    if (widget.direction == 'priority') {
      taskList = await Provider.of<TaskData>(context)
          .getTasksByPriority(widget.detail);
    } else if (widget.direction == 'category') {
      taskList = await Provider.of<TaskData>(context)
          .getTasksByCategory(widget.detail);
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getTasksList();
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final String allDoneAsset = 'assets/images/smile-regular.svg';

    final Widget allDoneSvg = SvgPicture.asset(
      allDoneAsset,
      width: SizeConfig.blockSizeVertical * 6,
      height: SizeConfig.blockSizeVertical * 6,
      color: kGrey,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskFullScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: SizeConfig.blockSizeHorizontal * 7,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff007ed4),
              const Color(0xff1a8ddb),
              const Color(0xff3ba5ed),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            child: taskList == null
                ? Container(
                    child: Center(
                      child: Text('Loading..'),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.01,
                                left: SizeConfig.screenWidth * 0.02,
                                right: SizeConfig.screenWidth * 0.02,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: kWhite,
                                size: SizeConfig.blockSizeVertical * 4.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.02,
                              bottom: SizeConfig.screenHeight * 0.01,
                            ),
                            child: Text(
                              capitalize(widget.direction + ": "),
                              style: TextStyle(
                                color: kWhite,
                                fontSize: SizeConfig.blockSizeVertical * 4,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.02,
                              bottom: SizeConfig.screenHeight * 0.01,
                            ),
                            child: Text(
                              capitalize(widget.detail),
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: SizeConfig.blockSizeVertical * 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight * 0.03,
                            left: SizeConfig.screenWidth * 0.03,
                            right: SizeConfig.screenWidth * 0.03,
                          ),
                          child: taskList.length == 0
                              ? Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        allDoneSvg,
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.screenHeight * 0.02,
                                            horizontal:
                                                SizeConfig.screenWidth * 0.01,
                                          ),
                                          child: Text(
                                            "Looks like you're all done. Tap + to add a new task",
                                            style: TextStyle(
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2.5,
                                              color: kGrey,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final task = taskList[index];
                                    return Row(
                                      children: [
                                        task.isChecked
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: SizeConfig
                                                          .blockSizeVertical *
                                                      4,
                                                ),
                                                onPressed: () {
                                                  print('IconButton pressed');
                                                  TodoNotifications()
                                                      .cancelNotificationById(
                                                          int.parse(task
                                                              .notificationId));
                                                  Provider.of<TaskData>(context,
                                                          listen: false)
                                                      .deleteTask(task);
                                                },
                                              )
                                            : Container(),
                                        Expanded(
                                          child: VersatileListTile(
                                            taskName: task.taskTitle,
                                            priority: task.priority,
                                            notes: task.notes,
                                            category: task.category,
                                            time: task.time,
                                            checkBoxCallback: () {
                                              if (!task.isChecked) {
                                                task.isChecked = true;
                                              } else {
                                                task.isChecked = false;
                                              }
                                              Provider.of<TaskData>(context,
                                                      listen: false)
                                                  .updateTask(task);
                                            },
                                            isChecked: task.isChecked,
                                            taskDate: task.date,
                                            task: task,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      height: SizeConfig.screenHeight * 0.01,
                                      color: Color.fromRGBO(234, 234, 234, 1),
                                    );
                                  },
                                  itemCount: taskList.length,
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class VersatileListTile extends StatelessWidget {
  VersatileListTile({
    this.taskName,
    this.priority,
    this.notes,
    this.category,
    this.time,
    this.checkBoxCallback,
    this.isChecked,
    this.taskDate,
    this.task,
  });

  final String taskName;

  final String priority;

  final String notes;

  final String category;

  final String time;

  final Function checkBoxCallback;

  final bool isChecked;

  final String taskDate;

  final Task task;

  MaterialColor returnPriorityColor() {
//    print('in listview, priority is $priority');
    if (priority == 'none')
      return kBlue;
//      return MaterialColor(0xFF9E9E9E, <int, Color>{
//        50: Color(0xFFF0F0F0),
//        200: Color(0xFFD6D6D6),
//      });
    else if (priority == 'low')
      return Colors.green;
    else if (priority == 'medium')
      return Colors.orange;
    else
      return Colors.red;
  }

  String dateParser() {
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

    int year = int.parse(taskDate.substring(0, 4));
    int month = int.parse(taskDate.substring(5, 7));
    int day = int.parse(taskDate.substring(8, 10));

    DateTime now = DateTime.now();
    if (year + month + day == now.year + now.month + now.day) {
      return 'Today';
    } else if (year + month + day == now.year + now.month + now.day + 1) {
      return 'Tomorrow';
    } else {
      return "$day ${intToMonth[month]} $year";
    }
  }

  bool DateBeforeOrAfter(String currTaskDate) {
    int taskYear = int.parse(taskDate.substring(0, 4));
    int taskMonth = int.parse(taskDate.substring(5, 7));
    int taskDay = int.parse(taskDate.substring(8, 10));

    DateTime taskDateTime = DateTime(taskYear, taskMonth, taskDay);

    int todayYear = DateTime.now().year;
    int todayMonth = DateTime.now().month;
    int todayDay = DateTime.now().day;

    DateTime todayDateTime = DateTime(todayYear, todayMonth, todayDay);

    if (taskDateTime.isAtSameMomentAs(todayDateTime) ||
        taskDateTime.isAfter(todayDateTime)) {
      return true;
    } else if (taskDateTime.isBefore(todayDateTime)) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth;

    if (task.isChecked) {
      screenWidth =
          SizeConfig.screenWidth - (16 + SizeConfig.blockSizeVertical * 4);
    } else {
      screenWidth = SizeConfig.screenWidth;
    }

    double blockSizeHorizontal = screenWidth / 100;

    SizeConfig().init(context);
    return GestureDetector(
      onTap: () async {
        String initialTaskTitle = task.taskTitle;
        if (!task.isChecked) {
          await showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              height: SizeConfig.screenHeight * 0.75,
              child: EditTaskSheet(
                task: task,
//              dateChangedCallback: (String newSelectedDate) {
//                setState(() {
//                  widget.task.date = newSelectedDate;
//                  Provider.of<TaskData>(context, listen: false).updateTask(widget.task);
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

          if (task.time == 'no time') {
            task.hasTime = false;
          }

          if (task.taskTitle.isEmpty) {
            task.taskTitle = initialTaskTitle;
          }

          Provider.of<TaskData>(context, listen: false).updateTask(task);
        }
      },
      child: Container(
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
//            color: returnPriorityColor().shade300,
            color: task.isChecked
                ? returnPriorityColor()[200]
                : returnPriorityColor()[400],
//            gradient: LinearGradient(
//              colors: [
////                returnPriorityColor().shade600,
//                returnPriorityColor().shade400,
//                returnPriorityColor().shade300,
//              ],
//              begin: Alignment.topCenter,
//              end: Alignment.bottomCenter,
//            ),
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
                  onTap: checkBoxCallback,
                  child: Container(
//              constraints: BoxConstraints.expand(),
//              height: SizeConfig.screenHeight,
//              height: 60,
                    alignment: Alignment.centerLeft,
                    child: CircleCheckBox(
                      icon: isChecked
                          ? Icon(
                              Icons.check,
                              color: kWhite,
                              size: SizeConfig.blockSizeVertical * 4,
                            )
                          : null,
                      priorityColor: returnPriorityColor(),
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
                      Row(
//                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              taskName,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                color: isChecked ? kWhite : kWhite,
                                decoration: isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              dateParser(),
                              style: TextStyle(
                                color: kWhite,
//                                color: DateBeforeOrAfter(taskDate)
//                                    ? kBlue
//                                    : Colors.red,
                                fontSize: blockSizeHorizontal * 4,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.screenHeight * 0.003),
                            child: Row(
                              children: <Widget>[
//                                Icon(
//                                  CustomFlagIcon.flag,
//                                  color: returnPriorityColor(),
//                                  size: blockSizeHorizontal * 5,
//                                ),
                                SizedBox(
                                  width: screenWidth * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: blockSizeHorizontal * 1.8,
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5,
                                  ),
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
                                  // Category tag
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        TaskCategory.tag,
                                        size: blockSizeHorizontal * 4,
                                        color: returnPriorityColor()[800],
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      Text(
                                        category,
                                        style: TextStyle(
                                          color: returnPriorityColor()[900],
                                          fontSize: blockSizeHorizontal * 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                task.alert == 'no reminder'
                                    ? Container()
                                    : Icon(
                                        Icons.notifications,
                                        color: kWhite,
                                        size: blockSizeHorizontal * 5.5,
                                      ),
                              ],
                            ),
                          ),
//                      Spacer(),
                          (time == 'no time' || time == null || !task.hasTime)
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
                                        color: returnPriorityColor()[200],
                                        blurRadius: 1.5,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      color: returnPriorityColor()[800],
                                      fontSize: blockSizeHorizontal * 4,
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

class CircleCheckBox extends StatelessWidget {
  CircleCheckBox({this.icon, this.priorityColor});

  final icon;

  final priorityColor;

  @override
  Widget build(BuildContext context) {
    return Container(
//      radius: SizeConfig.blockSizeVertical * 2.4,
      decoration: BoxDecoration(
        border: icon == null
            ? Border.all(
                color: priorityColor,
                width: 2,
              )
            : null,
        color: icon == null
            ? Colors.grey.shade400
            : kLightBlueAccent.withOpacity(0.0),
        shape: BoxShape.circle,
//        boxShadow: icon == null
//            ? [
//                BoxShadow(
//                  color: priorityColor,
//                  blurRadius: 0.8,
//                )
//              ]
//            : null,
      ),
      child: CircleAvatar(
        radius: SizeConfig.blockSizeVertical * 2.6,
        backgroundColor: icon == null
            ? priorityColor[50]
            : kLightBlueAccent.withOpacity(0.0),
        child: icon,
      ),
    );
  }
}

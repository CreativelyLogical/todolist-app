import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/models/date.dart';
import 'custom_flag_icon_icons.dart';
import 'task_category_icons.dart';
//import 'calendar_screen.dart';
import 'package:my_todo/widgets/edit_task_sheet.dart';
import 'package:my_todo/screens/add_task_fullscreen.dart';
import 'about_page.dart';
import 'task_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:my_todo/main.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/notifications/todo_notifications.dart';

class AllTasksScreen extends StatefulWidget {
  @override
  _AllTasksScreenState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  List<Task> allTasksList;

  Future _getAllTasksList() async {
    allTasksList = await Provider.of<TaskData>(context).getAllTaskList();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getAllTasksList();
//    setState(() {});
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

    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        print(
            'back button pressed, currently pagesOnStack is ${MyApp.pagesOnStack}');
        for (var i = 0; i < MyApp.pagesOnStack; i++) {
          SystemNavigator.pop();
        }
        return Future.value(true);
      },
      child: Scaffold(
//      backgroundColor: Colors.grey.shade200,
        backgroundColor: kBlue,
        bottomNavigationBar: BottomAppBar(
//          notchMargin: 5.0,
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
//            height: SizeConfig.screenHeight * 0.105,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.all(0),
//                      padding: EdgeInsets.only(
//                          right: SizeConfig.blockSizeHorizontal * 10),
                      icon: Icon(
                        Icons.view_week,
                        color: kWhite.withOpacity(0.5),
                      ),
                      iconSize: SizeConfig.screenHeight * 0.045,
                      onPressed: () {
                        MyApp.pagesOnStack++;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskScreen()));
                      },
                    ),
                    Text(
                      'Tasks',
                      style: TextStyle(
                          color: kWhite.withOpacity(0.6),
                          fontSize: SizeConfig.screenHeight * 0.02),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: kWhite,
                      ),
                      iconSize: SizeConfig.screenHeight * 0.045,
                      onPressed: () {
                        print("You're already in the all tasks page");
                      },
                    ),
                    Text(
                      'All Tasks',
                      style: TextStyle(
                          color: kWhite,
                          fontSize: SizeConfig.screenHeight * 0.02),
                    )
                  ],
                ),
                Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.all(0),
//                      padding: EdgeInsets.only(
//                          left: SizeConfig.blockSizeHorizontal * 10),
                      icon: Icon(
                        Icons.info_outline,
                        color: kWhite.withOpacity(0.5),
                      ),
                      iconSize: SizeConfig.screenHeight * 0.045,
                      onPressed: () {
                        MyApp.pagesOnStack++;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      },
//                color: kWhite,
                    ),
                    Text(
                      'About',
                      style: TextStyle(
                          color: kWhite.withOpacity(0.6),
                          fontSize: SizeConfig.screenHeight * 0.02),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
//          child: Padding(padding: EdgeInsets.only(bottom: 0.5)),
//          notchMargin: 10.0,
//          child: Padding(padding: EdgeInsets.all(20.0)),
          shape: CircularNotchedRectangle(),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
//        color: kWhite,
//          width: SizeConfig.screenWidth,
//          height: SizeConfig.screenHeight,

            child: allTasksList == null
                ? Container(
                    child: Center(
                      child: Text(
                        'Loading Tasks...',
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * 0.03,
                                bottom: SizeConfig.screenHeight * 0.01),
                            child: Text(
                              "All Tasks",
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 4,
                                color: kWhite,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: SizeConfig.blockSizeVertical * 4,
                              color: kWhite,
                            ),
                            padding: EdgeInsets.only(
                              right: SizeConfig.screenWidth * 0.04,
                              bottom: SizeConfig.screenHeight * 0.01,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskFullScreen(
                                    screen: 'AllTasksScreen',
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0))),
                          padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight * 0.03,
                            left: SizeConfig.screenWidth * 0.03,
                            right: SizeConfig.screenWidth * 0.03,
                          ),
                          child: allTasksList.length == 0
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
//                reverse: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final task = allTasksList[index];
//                  print('the type here is ${widget.type}');
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
                                                  Provider.of<TaskData>(context)
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
                                              Provider.of<TaskData>(context)
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
                                  itemCount: allTasksList.length),
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

  Color returnPriorityColor() {
    print('in listview, priority is $priority');
    if (priority == 'none')
      return Colors.grey.shade500;
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

          if (task.time == 'no time') {
            task.hasTime = false;
            Provider.of<TaskData>(context).updateTask(task);
          }
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
                                color: isChecked ? Colors.grey : kBlue,
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
                                color: DateBeforeOrAfter(taskDate)
                                    ? kBlue
                                    : Colors.red,
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
                                Icon(
                                  CustomFlagIcon.flag,
                                  color: returnPriorityColor(),
                                  size: blockSizeHorizontal * 5,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: blockSizeHorizontal * 1.8,
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
                                        size: blockSizeHorizontal * 4,
                                        color: kBlue,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      Text(
                                        category,
                                        style: TextStyle(
                                          color: kBlue,
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
                                        color: kBlue,
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
                                        color: Colors.grey,
                                        blurRadius: 1.5,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      color: kBlue,
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
        radius: SizeConfig.blockSizeVertical * 2.6,
        backgroundColor: icon == null
            ? Colors.grey.shade200
            : kLightBlueAccent.withOpacity(0.0),
        child: icon,
      ),
    );
  }
}
//class CircleCheckBox extends StatelessWidget {
//  CircleCheckBox({this.icon});
//
//  final icon;
//
//  @override
//  Widget build(BuildContext context) {
//    return CircleAvatar(
//      radius: SizeConfig.blockSizeVertical * 2.4,
//      backgroundColor: icon == null ? kBlue : kLightBlueAccent.withOpacity(0.0),
//      child: CircleAvatar(
//        radius: SizeConfig.blockSizeVertical * 2.2,
//        backgroundColor:
//            icon == null ? kWhite : kLightBlueAccent.withOpacity(0.0),
//        child: icon,
//      ),
//    );
//  }
//}

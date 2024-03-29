import 'package:flutter/material.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/screens/add_task_fullscreen.dart';
import 'package:my_todo/screens/task_screen.dart';
import 'custom_flag_icon_icons.dart';
import 'package:my_todo/screens/task_category_icons.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:my_todo/widgets/edit_task_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_todo/notifications/todo_notifications.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<List<Task>> getTaskList() async {
//      print('**********************');
//      List<Task> taskList = await Provider.of<TaskData>(context, listen: false)
//          .getTaskList(TaskScreen.selectedDay);
//      print('********************** taskList.length is ${taskList.length}');
      return await Provider.of<TaskData>(context)
          .getTaskList(TaskScreen.selectedDay);
    }

    bool snapshotIsEmpty(AsyncSnapshot<List<Task>> snapshot) {
      var initialData = [Task(taskTitle: 'nothing', isChecked: false)];

      print('snapshot.data in this function is ${snapshot.data}');
      return snapshot.data == initialData || snapshot.data.isEmpty;
    }

    final String allDoneAsset = 'assets/images/tasks-solid.svg';
    final Widget allDoneSvg = SvgPicture.asset(
      allDoneAsset,
      height: SizeConfig.blockSizeVertical * 6,
      width: SizeConfig.blockSizeVertical * 6,
      color: Colors.grey.shade700,
    );
    return FutureBuilder<List<Task>>(
//      initialData: Container(
//        child: Center(
//          child: Text('waiting for completion'),
//        ),
//      ),
      initialData: [Task(taskTitle: 'nothing', isChecked: false)],
      future: getTaskList(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        print('so snapshot.data.length is ${snapshot.data.length}');
        print('ok, snapshot.data  is ${snapshot.data}');

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
                        'Tasks ',
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
//                          print('add icon pressed');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddTaskFullScreen(
                                        screen: 'TaskListScreen',
                                      )));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: (snapshotIsEmpty(snapshot))
                  ? Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            allDoneSvg,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.screenHeight * 0.01,
                              ),
                              child: Text(
                                'Looks like there are no tasks for today',
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 3,
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
                      padding: EdgeInsets.only(top: 10.0),
                      itemBuilder: (BuildContext context, int index) {
                        final task = snapshot.data[index];
//                        print('so the title is ${task.taskTitle}');
//                        print('the task id in taskList is ${task.id}');
//                        print('the task is checked? ${task.isChecked}');
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            task.isChecked
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: SizeConfig.blockSizeVertical * 4,
                                    ),
                                    onPressed: () {
                                      TodoNotifications()
                                          .cancelNotificationById(
                                              int.parse(task.notificationId));
                                      Provider.of<TaskData>(context,
                                              listen: false)
                                          .deleteTask(task);
                                    },
                                  )
                                : Container(),
                            Expanded(
                              child: TaskListTile(
                                taskName: task.taskTitle,
                                isChecked: task.isChecked,
                                checkBoxCallback: () {
                                  if (!task.isChecked) {
                                    task.isChecked = true;
                                  } else {
                                    task.isChecked = false;
                                  }
                                  Provider.of<TaskData>(context, listen: false)
                                      .updateTask(task);
                                },
                                priority: task.priority,
                                notes: task.notes,
                                category: task.category,
                                alert: task.alert,
                                time: task.time,
                                task: task,
                              ),
                            ),
                          ],
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
  MaterialColor returnPriorityColor() {
//    print('in listview, priority is ${widget.priority}');
    if (widget.priority == 'none')
      return Colors.blue;
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
//      print('wtf is going on here');
    }

    double screenWidth;

    if (widget.isChecked) {
      screenWidth =
          SizeConfig.screenWidth - (16 + SizeConfig.blockSizeVertical * 4);
    } else {
      screenWidth = SizeConfig.screenWidth;
    }

//    double screenWidth = SizeConfig.screenWidth;
    double blockSizeHorizontal = screenWidth / 100;

    SizeConfig().init(context);
//    print('screenWidth of taskListTile is ${SizeConfig.screenWidth}');
    return GestureDetector(
      onTap: () async {
        String initialTaskTitle = widget.task.taskTitle;

        if (!widget.task.isChecked) {
          await showModalBottomSheet<String>(
            context: context,
            builder: (context) => Container(
              height: SizeConfig.screenHeight * 0.75,
              child: EditTaskSheet(
                task: widget.task,
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

          if (widget.task.time == 'no time') {
            widget.task.hasTime = false;
          }
          if (widget.task.taskTitle.isEmpty) {
            widget.task.taskTitle = initialTaskTitle;
          }
          // print('now the name of the task is ${widget.task.taskTitle}');
          Provider.of<TaskData>(context).updateTask(widget.task);
        }
      },
      child: Container(
          margin: EdgeInsets.only(
            left: widget.isChecked ? 0 : SizeConfig.screenWidth * 0.03,
            right: SizeConfig.screenWidth * 0.03,
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
//            color: kWhite,
            color: widget.task.isChecked
                ? returnPriorityColor()[200]
                : returnPriorityColor()[400],
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
                      Text(
                        widget.taskName,
//                        softWrap: true,
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.3,
//                          color: widget.isChecked ? Colors.grey : kBlue,
                          color: kWhite,
                          fontWeight: FontWeight.w400,
                          decoration: widget.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.screenHeight * 0.003,
                            ),
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
                                  // category tag
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        TaskCategory.tag,
                                        size: blockSizeHorizontal * 3.5,
//                                        color: kBlue,
                                        color: returnPriorityColor()[800],
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      AutoSizeText(
                                        widget.category == null
                                            ? 'none'
                                            : widget.category,
                                        maxLines: 1,
                                        style: TextStyle(
//                                          color: kBlue,
                                          color: returnPriorityColor()[900],
                                          fontSize: blockSizeHorizontal * 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // category
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                widget.alert == 'no reminder'
                                    ? Container()
                                    : Icon(
//                                        NotificationBells.bell,
                                        Icons.notifications,
                                        color: kWhite,
                                        size: blockSizeHorizontal * 5.5,
                                      )
                              ],
                            ),
                          ),
//                      Spacer(),
                          (widget.time == 'no time' ||
                                  widget.time == null ||
                                  !widget.task.hasTime)
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: blockSizeHorizontal * 1.5,
                                  ),
                                  decoration: BoxDecoration(
//                                  border: Border.all(color: kBlue, width: 1),
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    boxShadow: [
                                      BoxShadow(
//                                        color: Colors.grey,
                                        color: returnPriorityColor()[200],
                                        blurRadius: 1.5,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: AutoSizeText(
                                    widget.time,
                                    maxLines: 1,
                                    style: TextStyle(
//                                      color: kBlue,
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
            ? priorityColor[50]
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

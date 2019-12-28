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

class TaskListTile extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: SizeConfig.screenHeight * 0.7,
            child: EditTaskSheet(task),
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
                      Text(
                        taskName,
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                          color: kBlue,
                          fontWeight: FontWeight.w500,
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
                                notes == 'no notes'
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
                                        category,
                                        style: TextStyle(
                                          color: kBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
//                      Spacer(),
                          (time == 'no time' || time == null)
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
//  final String text;
//  final bool isChecked;
//
//  final Function checkBoxCallback;
//
//  final String priority;
//  final String notes;
//  final String category;
//  final String alert;
//  final String time;
//
//  final Task task;
//
//  TaskListTile({
//    this.text,
//    this.isChecked,
//    this.checkBoxCallback,
//    this.priority,
//    this.notes,
//    this.category,
//    this.alert,
//    this.time,
//    this.task,
//  });
//
//  Color returnPriorityColor() {
//    print('in listview, priority is $priority');
//    if (priority == 'none')
//      return Colors.grey.shade500;
//    else if (priority == 'low')
//      return Colors.green;
//    else if (priority == 'medium')
//      return Colors.orange;
//    else
//      return Colors.red;
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    if (notes.length > 0)
////      print('this task has notes');
////    else
////      print('this task has no notes');
//
//    print('so the notes are $notes');
////    print('the length of notes are ${notes.length}');
//    print('the alert is $alert');
//
//    SizeConfig().init(context);
//    return GestureDetector(
//      onTap: () {
//        showModalBottomSheet(
//          context: context,
//          builder: (context) => Container(
//            height: SizeConfig.screenHeight * 0.7,
//            child: EditTaskSheet(task),
//          ),
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(30.0),
//                topRight: Radius.circular(30.0)),
//          ),
//          isScrollControlled: true,
//        );
//      },
//      child: Container(
//        margin: EdgeInsets.only(
//          left: SizeConfig.screenWidth * 0.03,
//          right: SizeConfig.screenWidth * 0.03,
////        bottom: SizeConfig.blockSizeVertical * 0.3,
////        top: SizeConfig.blockSizeVertical * 0.3,
//        ),
//        decoration: BoxDecoration(
//          color: kWhite,
//          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//          boxShadow: [
//            BoxShadow(
//              color: Colors.grey,
//              blurRadius: 2,
//              offset: Offset(0, 1),
//            ),
//          ],
////          border: Border.all(color: kBlue, width: 2),
////        color: isChecked ? Colors.grey.shade200 : null,
//        ),
//        padding: EdgeInsets.only(
//          left: SizeConfig.screenWidth * 0.05,
//          right: SizeConfig.screenWidth * 0.05,
//          top: SizeConfig.screenHeight * 0.008,
//          bottom: SizeConfig.screenHeight * 0.008,
//        ),
//        child: Column(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                GestureDetector(
//                  onTap: checkBoxCallback,
//                  child: CircleCheckBox(
//                    icon: isChecked
//                        ? Icon(
//                            Icons.check,
//                            color: kBlue,
//                            size: SizeConfig.blockSizeVertical * 4,
//                          )
//                        : null,
//                  ),
//                ),
//                SizedBox(
//                  width: SizeConfig.blockSizeHorizontal * 5,
//                ),
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      text == null ? '' : text,
//                      style: TextStyle(
//                        fontSize: 15.0,
////                  color: isChecked ? kLightBlueAccent : kLightBlueAccent,
//                        color: kBlue,
//                        fontWeight: FontWeight.w600,
//                        fontFamily: 'Nunito',
//                        decoration:
//                            isChecked ? TextDecoration.lineThrough : null,
//                      ),
//                      maxLines: 2,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                    SizedBox(
//                      height: SizeConfig.screenHeight * 0.035,
//                      width: SizeConfig.screenWidth * 0.67,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        mainAxisSize: MainAxisSize.max,
//                        children: <Widget>[
//                          Container(
//                            alignment: Alignment.centerRight,
//                            child: Icon(
//                              CustomFlagIcon.flag,
//                              color: returnPriorityColor(),
//                              size: 18,
//                            ),
//                          ),
//                          SizedBox(
//                            width: SizeConfig.screenWidth * 0.02,
//                          ),
//                          notes == 'no notes'
//                              ? Container()
//                              : Container(
//                                  child: Icon(
//                                    NotesIndicator.doc_text,
//                                    color: kBlue,
//                                    size: 18,
//                                  ),
//                                ),
//                          SizedBox(
//                            width: SizeConfig.screenWidth * 0.02,
//                          ),
//                          Container(
//                            padding: EdgeInsets.symmetric(
//                                horizontal:
//                                    SizeConfig.blockSizeHorizontal * 1.5,
//                                vertical: SizeConfig.blockSizeVertical * 0.4),
//                            decoration: BoxDecoration(
//                              color: Colors.grey.shade100,
//                              boxShadow: [
//                                BoxShadow(
//                                  color: Colors.grey.shade500,
//                                  blurRadius: 1.5,
//                                  offset: Offset(0, 1),
//                                )
//                              ],
////                              border: Border.all(
////                                color: kBlue,
////                                width: 1,
////                              ),
//                              borderRadius:
//                                  BorderRadius.all(Radius.circular(20)),
//                            ),
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  TaskCategory.tag,
//                                  size: SizeConfig.blockSizeVertical * 2,
//                                  color: kBlue,
//                                ),
//                                SizedBox(
//                                  width: 2,
//                                ),
//                                Text(
//                                  category == null ? 'something' : category,
//                                  style: TextStyle(
//                                    color: kBlue,
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                          SizedBox(
//                            width: SizeConfig.screenWidth * 0.02,
//                          ),
//                          alert == 'no reminders'
//                              ? Container()
//                              : Icon(
//                                  NotificationBell.bell,
//                                  size: SizeConfig.blockSizeVertical * 2,
//                                  color: kBlue,
//                                ),
//                          Spacer(),
//                          Align(
//                            alignment: Alignment.centerRight,
//                            child: (time == 'no time' || time == null)
//                                ? Container()
//                                : Container(
//                                    padding: EdgeInsets.symmetric(
//                                      horizontal:
//                                          SizeConfig.blockSizeHorizontal * 1.5,
//                                    ),
//                                    decoration: BoxDecoration(
//                                      color: Colors.grey.shade100,
//                                      borderRadius: BorderRadius.all(
//                                        Radius.circular(
//                                          20.0,
//                                        ),
//                                      ),
//                                      boxShadow: [
//                                        BoxShadow(
//                                          color: Colors.grey,
//                                          blurRadius: 1.5,
//                                          offset: Offset(0, 1),
//                                        )
//                                      ],
//                                    ),
//                                    child: Text(
//                                      time,
//                                      style: TextStyle(
//                                        color: kBlue,
//                                      ),
//                                      textAlign: TextAlign.right,
//                                    ),
//                                  ),
//                          )
//                        ],
//                      ),
//                    ),
//
////                  Text(
////                    '${TaskScreen.selectedDay.day} ${TaskScreen.selectedDay.month}',
////                    style: TextStyle(
////                      color: kBlue,
////                      fontSize: 16,
////                    ),
////                  ),
//                  ],
//                ),
////              notes == null
////                  ? Container()
////                  : Expanded(
////                      child: Container(
////                        child: Icon(
////                          NotesIndicator.doc_text,
////                          color:
////                              notes.length == 0 ? kBlue.withOpacity(0) : kBlue,
////                        ),
////                      ),
////                    ),
////              Expanded(
////                child: Container(
////                  alignment: Alignment.centerRight,
////                  child: Icon(
////                    CustomFlagIcon.flag,
////                    color: returnPriorityColor(),
////                  ),
////                ),
////              ),
//              ],
//            ),
//          ],
//        ),
//      ),
//    );
//  }
}

class EditTaskSheet extends StatefulWidget {
  EditTaskSheet(this.task);

  final Task task;

  @override
  _EditTaskSheetState createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  Task _task;

  String selectedPriority;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTask();
  }

  void setTask() {
    _task = widget.task;
    selectedPriority = _task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PriorityButtons(
                selectedPriority: selectedPriority,
                priority: 'none',
                onTap: () {
                  setState(() {
                    selectedPriority = 'none';
                    _task.priority = selectedPriority;
                    Provider.of<TaskData>(context).updateTask(_task);
                  });
                },
                screen: 'edit_task',
              ),
              PriorityButtons(
                selectedPriority: selectedPriority,
                priority: 'low',
                onTap: () {
                  setState(() {
                    selectedPriority = 'low';
                    _task.priority = selectedPriority;
                    Provider.of<TaskData>(context).updateTask(_task);
                  });
                },
                screen: 'edit_task',
              ),
              PriorityButtons(
                selectedPriority: selectedPriority,
                priority: 'medium',
                onTap: () {
                  setState(() {
                    selectedPriority = 'medium';
                    _task.priority = selectedPriority;
                    Provider.of<TaskData>(context).updateTask(_task);
                  });
                },
                screen: 'edit_task',
              ),
              PriorityButtons(
                selectedPriority: selectedPriority,
                priority: 'high',
                onTap: () {
                  setState(() {
                    selectedPriority = 'high';
                    _task.priority = selectedPriority;
                    Provider.of<TaskData>(context).updateTask(_task);
                  });
                },
                screen: 'edit_task',
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: DateButton(),
          ),
        ],
      ),
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
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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

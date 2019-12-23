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
      List<Task> taskList = await Provider.of<TaskData>(context).getTaskList();
      print('********************** taskList.length is ${taskList.length}');
      return await Provider.of<TaskData>(context).getTaskList();
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
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.screenHeight * 0.01),
              height: SizeConfig.screenHeight * 0.085,
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
                        return ListTile(
                          text: task.taskTitle,
                          isChecked: task.isChecked,
                          checkBoxCallback: () {
                            Provider.of<TaskData>(context).updateTask(task);
                          },
                          priority: task.priority,
                          notes: task.notes,
                          category: task.category,
                          alert: task.alert,
                          time: task.time,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        height: SizeConfig.screenHeight * 0.01,
                        color: kWhite,
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

class ListTile extends StatelessWidget {
  final String text;
  final bool isChecked;

  final Function checkBoxCallback;

  final String priority;
  final String notes;
  final String category;
  final String alert;
  final String time;

  ListTile(
      {this.text,
      this.isChecked,
      this.checkBoxCallback,
      this.priority,
      this.notes,
      this.category,
      this.alert,
      this.time});

  Color returnPriorityColor() {
    print('in listview, priority is $priority');
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
//    if (notes.length > 0)
//      print('this task has notes');
//    else
//      print('this task has no notes');

    print('so the notes are $notes');
//    print('the length of notes are ${notes.length}');
    print('the alert is $alert');

    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(
//        bottom: SizeConfig.blockSizeVertical * 0.3,
//        top: SizeConfig.blockSizeVertical * 0.3,
          ),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: kBlue, width: 2),
//        color: isChecked ? Colors.grey.shade200 : null,
      ),
      padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.05,
          right: SizeConfig.screenWidth * 0.05,
          top: SizeConfig.screenHeight * 0.008,
          bottom: SizeConfig.screenHeight * 0.008),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: checkBoxCallback,
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
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15.0,
//                  color: isChecked ? kLightBlueAccent : kLightBlueAccent,
                      color: kBlue,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.035,
                    width: SizeConfig.screenWidth * 0.67,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            CustomFlagIcon.flag,
                            color: returnPriorityColor(),
                            size: 18,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.01,
                        ),
                        notes == 'no notes'
                            ? Container()
                            : Container(
                                child: Icon(
                                  NotesIndicator.doc_text,
                                  color: notes.length == 0
                                      ? kBlue.withOpacity(0)
                                      : kBlue,
                                  size: 18,
                                ),
                              ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.01,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 1.5,
                              vertical: SizeConfig.blockSizeVertical * 0.4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kBlue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                TaskCategory.tag,
                                size: SizeConfig.blockSizeVertical * 2,
                                color: kBlue,
                              ),
                              SizedBox(
                                width: 2,
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
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.01,
                        ),
                        alert == 'no reminders'
                            ? Container()
                            : Icon(
                                NotificationBell.bell,
                                size: SizeConfig.blockSizeVertical * 2,
                                color: kBlue,
                              ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 1.5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: kBlue, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20.0,
                                ),
                              ),
                            ),
                            child: Text(
                              time == 'no time' ? '' : time,
                              style: TextStyle(
                                color: kBlue,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

//                  Text(
//                    '${TaskScreen.selectedDay.day} ${TaskScreen.selectedDay.month}',
//                    style: TextStyle(
//                      color: kBlue,
//                      fontSize: 16,
//                    ),
//                  ),
                ],
              ),
//              notes == null
//                  ? Container()
//                  : Expanded(
//                      child: Container(
//                        child: Icon(
//                          NotesIndicator.doc_text,
//                          color:
//                              notes.length == 0 ? kBlue.withOpacity(0) : kBlue,
//                        ),
//                      ),
//                    ),
//              Expanded(
//                child: Container(
//                  alignment: Alignment.centerRight,
//                  child: Icon(
//                    CustomFlagIcon.flag,
//                    color: returnPriorityColor(),
//                  ),
//                ),
//              ),
            ],
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
    return CircleAvatar(
      radius: SizeConfig.blockSizeVertical * 2.4,
      backgroundColor: icon == null ? kBlue : kLightBlueAccent.withOpacity(0.0),
      child: CircleAvatar(
        radius: SizeConfig.blockSizeVertical * 2.2,
        backgroundColor:
            icon == null ? kWhite : kLightBlueAccent.withOpacity(0.0),
        child: icon,
      ),
    );
  }
}

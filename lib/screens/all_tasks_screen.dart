import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/models/date.dart';
import 'custom_flag_icon_icons.dart';
import 'package:my_todo/widgets/notes_indicator_icons.dart';
import 'task_category_icons.dart';

class AllTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kWhite,
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
//                  crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(0),
//                      padding: EdgeInsets.only(
//                          left: SizeConfig.blockSizeHorizontal * 10),
                    icon: Icon(
                      Icons.date_range,
                      color: kWhite.withOpacity(0.5),
                    ),
                    iconSize: SizeConfig.screenHeight * 0.045,

//                color: kWhite,
                  ),
                  Text(
                    'Calendar',
                    style: TextStyle(
                        color: kWhite.withOpacity(0.6),
                        fontSize: SizeConfig.screenHeight * 0.02),
                    textAlign: TextAlign.start,
                  )
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
                  ),
                  Text(
                    'All tasks',
                    style: TextStyle(
                        color: kWhite,
                        fontSize: SizeConfig.screenHeight * 0.02),
                  )
                ],
              ),
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
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Week View',
                    style: TextStyle(
                        color: kWhite.withOpacity(0.6),
                        fontSize: SizeConfig.screenHeight * 0.02),
                  ),
                ],
              )
            ],
          ),
        ),
//          child: Padding(padding: EdgeInsets.only(bottom: 0.5)),
//          notchMargin: 10.0,
//          child: Padding(padding: EdgeInsets.all(20.0)),
        shape: CircularNotchedRectangle(),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.only(
          top: SizeConfig.screenHeight * 0.1,
          left: SizeConfig.screenWidth * 0.03,
          right: SizeConfig.screenWidth * 0.03,
        ),
        child: Column(
          children: <Widget>[
            ListObjects(
              day: 'today',
            ),
            ListObjects(
              day: 'tomorrow',
            )
          ],
        ),
      ),
    );
  }
}

class ListObjects extends StatefulWidget {
  @override
  _ListObjectsState createState() => _ListObjectsState();

  ListObjects({this.day});

  final String day;
}

class _ListObjectsState extends State<ListObjects> {
  List<Task> taskList;

//  Future getTaskList() async {
//    taskList =  await Provider.of<TaskData>(context)
//        .getTaskList(Date(DateTime.now()));
//  }

  Future _getTodayTaskList() async {
    Date listDay;
    if (widget.day == 'today')
      listDay = Date(DateTime.now());
    else if (widget.day == 'tomorrow')
      listDay = Date(DateTime.now().add(Duration(days: 1)));
    taskList = await Provider.of<TaskData>(context).getTaskList(listDay);
    setState(() {});
//    if (taskList != null) {
//      setState(() {
//        print('taskList.length is ${taskList.length}');
//      });
//    }
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getTodayTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
//                  left: SizeConfig.screenWidth * 0.04,
//                  bottom: SizeConfig.screenHeight * 0.01,
                    ),
                child: Text(
                  widget.day == 'today' ? 'Today' : 'Tomorrow',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical * 3.5,
                    color: kBlue,
                  ),
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                color: kBlue,
                size: 30,
              ),
            ],
          ),
          taskList == null
              ? Container(
                  child: Center(
                    child: Text('no data currently'),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(top: 10.0),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final task = taskList[index];
                    return TodayListTile(
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
                        Provider.of<TaskData>(context).updateTask(task);
                      },
                      isChecked: task.isChecked,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: SizeConfig.screenHeight * 0.01,
                      color: kWhite,
                    );
                  },
                  itemCount: taskList.length)
        ],
      ),
    );
  }
}

class TodayListTile extends StatelessWidget {
  TodayListTile({
    this.taskName,
    this.priority,
    this.notes,
    this.category,
    this.time,
    this.checkBoxCallback,
    this.isChecked,
  });

  final String taskName;

  final String priority;

  final String notes;

  final String category;

  final String time;

  final Function checkBoxCallback;

  final bool isChecked;

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
    return Container(
        padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.05,
          right: SizeConfig.screenWidth * 0.05,
          top: SizeConfig.screenHeight * 0.005,
          bottom: SizeConfig.screenHeight * 0.005,
        ),
        decoration: BoxDecoration(
//          color: Colors.grey.shade200,
          border: Border.all(color: kBlue, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        color: kBlue,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 0.4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
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
                                      size: SizeConfig.blockSizeVertical * 2.5,
                                    ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 1.5,
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: kBlue, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
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
                                  border: Border.all(color: kBlue, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
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
//              Expanded(
//                child: Row(
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  children: <Widget>[
//                    IntrinsicHeight(
//                      child: Column(
////                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: <Widget>[
//                          (time == 'no time' || time == null)
//                              ? Container()
//                              : Container(
//                                  padding: EdgeInsets.symmetric(
//                                    horizontal:
//                                        SizeConfig.blockSizeHorizontal * 1.5,
//                                  ),
//                                  decoration: BoxDecoration(
//                                    border: Border.all(
//                                      color: kBlue,
//                                      width: 1,
//                                    ),
//                                    borderRadius:
//                                        BorderRadius.all(Radius.circular(20.0)),
//                                  ),
//                                  child: Text(
//                                    time,
//                                    style: TextStyle(
//                                      color: kBlue,
//                                    ),
//                                  ),
//                                ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ),
            ],
          ),
        ));
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

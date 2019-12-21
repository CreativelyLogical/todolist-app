import 'package:flutter/material.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/size_config.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/screens/add_task_fullscreen.dart';

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
              height: SizeConfig.screenHeight * 0.08,
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
                  ? Container()
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
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        height: SizeConfig.screenHeight * 0.02,
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

  ListTile({this.text, this.isChecked, this.checkBoxCallback});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(
//        bottom: SizeConfig.blockSizeVertical * 0.3,
//        top: SizeConfig.blockSizeVertical * 0.3,
          ),
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 10.0,
              offset: Offset(1, 4),
            ),
          ]
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
              Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
//                  color: isChecked ? kLightBlueAccent : kLightBlueAccent,
                  color: kBlue,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
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

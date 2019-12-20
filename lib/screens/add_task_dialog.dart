import 'package:flutter/material.dart';
import 'package:my_todo/size_config.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'task_screen.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();

    SizeConfig().init(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenHeight * 0.02,
          horizontal: SizeConfig.screenWidth * 0.08,
        ),
        width: SizeConfig.screenWidth * 0.90,
        height: SizeConfig.screenHeight * 0.35,
        child: Column(
          children: <Widget>[
            Text(
              'New Task',
              style: TextStyle(
                color: Color.fromRGBO(66, 99, 236, 1.0),
                fontSize: SizeConfig.screenHeight * 0.034,
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.05,
            ),
            TextField(
              controller: textEditingController,
              style: TextStyle(
                fontSize: 20,
              ),
              autofocus: true,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  color: Colors.red,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.screenHeight * 0.02),
                  ),
                  onPressed: () {
                    Provider.of<TaskData>(context).dropTable();
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
//                SizedBox(
//                  width: 5,
//                ),
                FlatButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  color: Colors.lightGreen,
                  child: Text(
                    'Enter',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.screenHeight * 0.02),
                  ),
                  onPressed: () {
                    String taskTitle = textEditingController.text;
                    Provider.of<TaskData>(context)
                        .addTask(taskTitle, TaskScreen.selectedDay);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
//      color: Colors.white,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          Text(
//            'New Task',
//            style: TextStyle(
//                color: Color.fromRGBO(66, 99, 236, 1.0),
//                fontSize: SizeConfig.screenHeight * 0.037),
//          ),
//          SizedBox(
//            height: SizeConfig.screenHeight * 0.05,
//          ),
//          Padding(
//            padding:
//                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
//            child: TextField(
//              autofocus: true,
//              style: TextStyle(fontSize: 20),
//              textAlign: TextAlign.center,
//            ),
//          ),
//          SizedBox(
//            height: SizeConfig.screenHeight * 0.12,
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              FlatButton(
//                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
//                color: Colors.red,
//                child: Text(
//                  'Cancel',
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: SizeConfig.screenHeight * 0.035),
//                ),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                ),
//              ),
//              FlatButton(
//                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
//                color: Colors.lightGreen,
//                child: Text(
//                  'Enter',
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: SizeConfig.screenHeight * 0.035),
//                ),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                ),
//              )
//            ],
//          )
//        ],
//      ),
//      decoration: BoxDecoration(
//        color: Colors.white,
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
//      ),

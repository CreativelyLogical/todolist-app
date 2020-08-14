import 'package:flutter/material.dart';
import 'package:my_todo/widgets/task_list.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/models/date.dart';
import 'package:my_todo/widgets/week_view.dart';
import 'all_tasks_screen.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();

  static Date selectedDay = Date(DateTime.now());
}

class _TaskScreenState extends State<TaskScreen> {
  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));
  }

  Map<int, String> months = {
    1: 'Jan',
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "July",
    8: "Aug",
    9: "Sept",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };

  String getDate() {
    int day = DateTime.now().day;
    String month = months[DateTime.now().month];

    return "$month $day";
  }

  void setStateCallback() {
    setState(() {
      print('this is called');
    });
  }

  String selectedText = 'Today';

  @override
  Widget build(BuildContext context) {
    print(context);
    SizeConfig().init(context);
    print('The height of this device is ${SizeConfig.screenHeight}');
    print('The width of this device is ${SizeConfig.screenWidth}');
    getDate();
    print('blockSizeVertical is ${SizeConfig.blockSizeVertical}');
    print('blockSizeHorizontal is ${SizeConfig.blockSizeHorizontal}');

    int tasksRemaining = 4;

    double selectedTextSize =
        (SizeConfig.blockSizeVertical * SizeConfig.blockSizeHorizontal) * 1.2;

    double deselectedTextSize =
        (SizeConfig.blockSizeVertical * SizeConfig.blockSizeHorizontal) * 0.9;

    Color selectedColor = Colors.white;
    Color deselectedColor = Colors.white.withOpacity(0.6);

    return Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1.5),
//          child: FloatingActionButton(
//            onPressed: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => AddTaskFullScreen()));
////              showDialog(
////                context: context,
////                builder: (context) => AddTaskDialog(),
////              );
////              showModalBottomSheet(
////                isScrollControlled: true,
////                context: context,
////                shape: RoundedRectangleBorder(
////                  borderRadius: BorderRadius.only(
////                      topLeft: Radius.circular(40.0),
////                      topRight: Radius.circular(40.0)),
////                ),
////                builder: (context) => AddTaskScreen(),
////              );
////                backgroundColor: Colors.white);
//            },
//            backgroundColor: kBlue,
//            child: Icon(Icons.add, color: Colors.white),
//          ),
        ),
//        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//        backgroundColor: Color.fromRGBO(66, 99, 236, 1.0),
//        appBar: AppBar(
//          title: Text('Todo'),
        backgroundColor: kBlue,
//        backgroundColor: Colors.lightBlueAccent,
//        ),
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
                        color: kWhite,
                      ),
                      iconSize: SizeConfig.screenHeight * 0.045,
                      onPressed: () {
                        print("You're already in the week view screen");
                      },
                    ),
                    Text(
                      'Week View',
                      style: TextStyle(
                          color: kWhite,
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
                        color: kWhite.withOpacity(0.5),
                      ),
                      iconSize: SizeConfig.screenHeight * 0.045,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllTasksScreen()));
                      },
                    ),
                    Text(
                      'All Tasks',
                      style: TextStyle(
                          color: kWhite.withOpacity(0.6),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            WeekView(
              setStateCallback: () {
                setState(() {
                  print('setState has been called in task screen');
                });
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                child: TaskList(),
              ),
            ),
          ],
        ));
  }
}

//Color getDayColor(String weekday) {
//  Map
//}

//EdgeInsets.only(
//top: SizeConfig.screenHeight * 0.05,
//left: SizeConfig.screenWidth * 0.1)

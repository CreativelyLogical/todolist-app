import 'package:flutter/material.dart';
import 'package:my_todo/widgets/task_list.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:my_todo/size_config.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'add_task_dialog.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:my_todo/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_todo/models/date.dart';
import 'package:my_todo/screens/add_task_fullscreen.dart';
import 'package:my_todo/widgets/day_container.dart';
import 'package:my_todo/widgets/week_view.dart';

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
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTaskFullScreen()));
//              showDialog(
//                context: context,
//                builder: (context) => AddTaskDialog(),
//              );
//              showModalBottomSheet(
//                isScrollControlled: true,
//                context: context,
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(40.0),
//                      topRight: Radius.circular(40.0)),
//                ),
//                builder: (context) => AddTaskScreen(),
//              );
//                backgroundColor: Colors.white);
            },
            backgroundColor: kBlue,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//        backgroundColor: Color.fromRGBO(66, 99, 236, 1.0),
//        appBar: AppBar(
//          title: Text('Todo'),
        backgroundColor: kWhite,
//        backgroundColor: Colors.lightBlueAccent,
//        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5.0,
          child: Container(
            height: SizeConfig.blockSizeVertical * 9,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 10),
                  icon: Icon(
                    Icons.date_range,
                    color: kWhite,
                  ),
                  iconSize: SizeConfig.blockSizeVertical * 6,
//                color: kWhite,
                ),
                IconButton(
                  padding: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 10),
                  icon: Icon(
                    Icons.settings,
                    color: kWhite,
                  ),
                  iconSize: SizeConfig.blockSizeVertical * 6,
                )
              ],
            ),
          ),
//          child: Padding(padding: EdgeInsets.only(bottom: 0.5)),
//          notchMargin: 10.0,
//          child: Padding(padding: EdgeInsets.all(20.0)),
          shape: CircularNotchedRectangle(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WeekView(
              setStateCallback: () {
                setState(() {
                  print('setState has been called in task screen');
                });
              },
            ),

//            Container(
//              decoration: BoxDecoration(
//                color: Colors.blue,
//                borderRadius: BorderRadius.only(
//                    bottomLeft: Radius.circular(15.0),
//                    bottomRight: Radius.circular(15.0)),
//              ),
//              child: Column(
//                textBaseline: TextBaseline.alphabetic,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Padding(
//                          padding: EdgeInsets.only(
//                            top: SizeConfig.screenHeight * 0.035,
//                            bottom: 5,
//                          ),
//                          child: Text(
//                            TaskScreen.selectedDay.month,
//                            style: TextStyle(
//                              color: kWhite,
//                              fontSize: 30.0,
//                            ),
//                            textAlign: TextAlign.center,
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(
////                      left: SizeConfig.screenWidth * 0.05,
////                      bottom: SizeConfig.screenHeight * 0.015,
//                        ),
//                    child: SizedBox(
//                      height: SizeConfig.screenHeight * 0.125,
//                      child: Container(
////                          color: kLightBlueAccent,
////                    margin: EdgeInsets.only(bottom: 10.0),
////                    padding: EdgeInsets.only(bottom: 15.0),
//                          child: Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.center,
////                        mainAxisAlignment: MainAxisAlignment.spaceAround,
////                  padding: EdgeInsets.only(bottom: 20),
////                        scrollDirection: Axis.horizontal,
//                        children: <Widget>[
//                          DayContainer(
//                            today: DateTime.now(),
//                            inputWeekday: 0,
//                            setStateCallback: () {
//                              setState(() {});
//                            },
//                          ),
//                          DayContainer(
//                            today: DateTime.now(),
//                            inputWeekday: 1,
//                            setStateCallback: () {
//                              setState(() {});
//                            },
//                          ),
//                          DayContainer(
//                            today: DateTime.now(),
//                            inputWeekday: 2,
//                            setStateCallback: () {
//                              setState(() {});
//                            },
//                          ),
//                          DayContainer(
//                            today: DateTime.now(),
//                            inputWeekday: 3,
//                            setStateCallback: () {
//                              setState(() {});
//                            },
//                          ),
//                          DayContainer(
//                            today: DateTime.now(),
//                            inputWeekday: 4,
//                            setStateCallback: () {
//                              setState(() {});
//                            },
//                          ),
//                          DayContainer(
//                            today: DateTime.now(),
//                            inputWeekday: 5,
//                            setStateCallback: () {
//                              setState(() {});
//                            },
//                          ),
//                          DayContainer(
//                            today: DateTime.now(),
//                            inputWeekday: 6,
//                            setStateCallback: () {
//                              setState(() {});
//                            },
//                          ),
//                        ],
//                      )),
//                    ),
//                  ),
//                ],
//              ),
//            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
//                    bottom: SizeConfig.screenHeight * 0.06,
                    left: SizeConfig.screenWidth * 0.03,
                    right: SizeConfig.screenWidth * 0.03),
                decoration: BoxDecoration(
//                  color: kRallyGreen,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                padding: EdgeInsets.only(
//                      bottom: SizeConfig.blockSizeVertical * 12,
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3),
                child: TaskList(),
              ),
            )
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

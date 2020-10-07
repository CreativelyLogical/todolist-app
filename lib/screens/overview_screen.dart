import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'all_tasks_screen.dart';
import 'about_page.dart';
import 'package:my_todo/main.dart';
import 'task_screen.dart';
import 'package:my_todo/models/task_data_holder.dart';
import 'package:my_todo/models/task.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'add_task_fullscreen.dart';

const PRIORITY = 'PRIORITY';
const CATEGORY = 'CATEGORY';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<Task> allTasksList = [];

  Future _getAllTasksList() async {
    allTasksList = await Provider.of<TaskData>(context).getAllTaskList();
    setState(() {});
  }

  String userViewState = PRIORITY;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getAllTasksList();
//    setState(() {});
  }

  var priorities = ["high", "medium", "low", "none"];
  var categories = ["School", "Business", "Personal", "Work"];

  Color getColorByPriority(index) {
    if (priorities[index] == 'high') {
      return Colors.red;
    } else if (priorities[index] == 'medium') {
      return Colors.orange;
    } else if (priorities[index] == 'low') {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  Color getColorsByCategory(index) {
    if (categories[index] == 'Personal') {
      return Colors.green;
    } else if (categories[index] == 'Work') {
      return Colors.blue;
    } else if (categories[index] == 'School') {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

//  LinearGradient getContainerColor(index) {
//    if (priorities[index] == 'high') {
//      return LinearGradient(
//        colors: [
//          const Color(0xffe60b0b),
//          const Color(0xfff57171),
//        ],
//        begin: Alignment.topLeft,
//        end: Alignment.bottomRight,
//      );
//    } else if (priorities[index] == 'medium') {
//      return LinearGradient(
//        colors: [
//          const Color(0xfff28416),
//          const Color(0xffffc37a),
//        ],
//        begin: Alignment.topLeft,
//        end: Alignment.bottomRight,
//      );
//    } else if (priorities[index] == 'low') {
//      return LinearGradient(
//        colors: [
//          const Color(0xff07ba16),
//          const Color(0xff8ff297),
//        ],
//        begin: Alignment.topLeft,
//        end: Alignment.bottomRight,
//      );
//    } else {
//      return LinearGradient(
//        colors: [
//          const Color(0xff0489d6),
//          const Color(0xff7fcaf5),
//        ],
//        begin: Alignment.topLeft,
//        end: Alignment.bottomRight,
//      );
//    }
//  }

  dynamic getNumTasksByPriorityOrCategory(int index) {
    String priority = priorities[index];
    String category = categories[index];
    int numTasks = 0;
    int doneTasks = 0;
    if (allTasksList.length == 0) {
      return [0, 0.0];
    } else {
      for (int i = 0; i < allTasksList.length; i++) {
        if (userViewState == PRIORITY) {
          if (allTasksList[i].priority == priority) {
            numTasks++;
            if (allTasksList[i].isChecked) {
              doneTasks++;
            }
          }
        } else {
          if (allTasksList[i].category == category) {
            numTasks++;
            if (allTasksList[i].isChecked) {
              doneTasks++;
            }
          }
        }
      }
    }

    return ["$doneTasks of $numTasks completed", (doneTasks / numTasks)];
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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBar: BottomAppBar(
//          notchMargin: 5.0,
        child: Container(
          padding: EdgeInsets.only(
            bottom: 5,
            top: 10,
          ),

//            height: SizeConfig.screenHeight * 0.105,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: Icon(
                  Icons.home,
                  size: SizeConfig.screenHeight * 0.035,
                  color: kBlue,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
//                      padding: EdgeInsets.only(
//                          right: SizeConfig.blockSizeHorizontal * 10),
                icon: Icon(
                  Icons.view_week,
                  color: kWhite.withOpacity(0.5),
                ),
                iconSize: SizeConfig.screenHeight * 0.035,
                onPressed: () {
                  MyApp.pagesOnStack++;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TaskScreen()));
                },
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.format_list_bulleted,
                  color: kWhite.withOpacity(0.5),
                ),
                iconSize: SizeConfig.screenHeight * 0.035,
                onPressed: () {
                  MyApp.pagesOnStack++;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllTasksScreen()));
                },
              ),
              IconButton(
                padding: EdgeInsets.all(0),
//                      padding: EdgeInsets.only(
//                          left: SizeConfig.blockSizeHorizontal * 10),
                icon: Icon(
                  Icons.info,
                  color: kWhite.withOpacity(0.5),
                ),
                iconSize: SizeConfig.screenHeight * 0.035,
                onPressed: () {
                  MyApp.pagesOnStack++;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
//                color: kWhite,
              ),
            ],
          ),
        ),
//          child: Padding(padding: EdgeInsets.only(bottom: 0.5)),
//          notchMargin: 10.0,
//          child: Padding(padding: EdgeInsets.all(20.0)),
        shape: CircularNotchedRectangle(),
      ),
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: SizeConfig.screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
//                color: kBlue,
              gradient: LinearGradient(
                colors: [
                  const Color(0xff007ed4),
                  const Color(0xff1a8ddb),
                  const Color(0xff3ba5ed),
                ],
              ),
              borderRadius: BorderRadius.only(
//                  bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.screenHeight * 0.03,
                      left: SizeConfig.screenWidth * 0.03,
                    ),
                    child: Text(
                      'Oct 4th, 2020',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: SizeConfig.blockSizeHorizontal * 10,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          userViewState = PRIORITY;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: SizeConfig.screenHeight * 0.03,
                          left: SizeConfig.screenWidth * 0.03,
                          bottom: SizeConfig.screenHeight * 0.03,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeHorizontal * 1,
                          horizontal: SizeConfig.blockSizeHorizontal * 3,
                        ),
//                        decoration: userViewState == PRIORITY
//                            ? BoxDecoration(
//                                color: kWhite,
//                                borderRadius: BorderRadius.all(
//                                  Radius.circular(15),
//                                ),
//                              )
//                            : null,
                        child: Text(
                          'Priority',
                          style: TextStyle(
                            color: userViewState == PRIORITY
                                ? kWhite
                                : kWhite.withOpacity(0.6),
                            fontSize: SizeConfig.blockSizeHorizontal * 7.5,
//                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          userViewState = CATEGORY;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeHorizontal * 1,
                          horizontal: SizeConfig.blockSizeHorizontal * 3,
                        ),
//                        decoration: userViewState == CATEGORY
//                            ? BoxDecoration(
//                                color: kWhite,
//                                borderRadius: BorderRadius.all(
//                                  Radius.circular(15),
//                                ),
//                              )
//                            : null,
                        child: Text(
                          'Category',
                          style: TextStyle(
                            color: userViewState == PRIORITY
                                ? kWhite.withOpacity(0.6)
                                : kWhite,
                            fontSize: SizeConfig.blockSizeHorizontal * 7.5,
//                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: List.generate(
                4,
                (index) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.white,
//                      gradient: getContainerColor(index),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          left: 16,
                        ),
                        child: Text(
                          userViewState == PRIORITY
                              ? capitalize(priorities[index])
                              : categories[index],
                          style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontSize: SizeConfig.blockSizeHorizontal * 8,
                            fontWeight: FontWeight.bold,
                            color: getColorByPriority(index),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                          left: 16,
                        ),
                        child: Text(
                          getNumTasksByPriorityOrCategory(index)[0].toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          left: 16,
                        ),
                        child: Row(
                          children: [
//                              new LinearPercentIndicator(
//                                width: 150,
//                                lineHeight: 8.0,
//                                percent: getNumTasksByPriority(index)[1],
//                                progressColor: Colors.blue,
//                              )
                            new CircularPercentIndicator(
                              animation: true,
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: SizeConfig.blockSizeHorizontal * 10,
                              lineWidth: 7.0,
                              percent:
                                  getNumTasksByPriorityOrCategory(index)[1],
                              backgroundColor: Colors.grey[300],
                              progressColor: getColorByPriority(index),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

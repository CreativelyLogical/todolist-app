import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_todo/models/date.dart';
import 'package:my_todo/screens/task_screen.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/constants.dart';

class DayContainer extends StatefulWidget {
  DayContainer({this.today, this.inputWeekday, this.setStateCallback});

  final DateTime today;

  final int inputWeekday;

  final Function setStateCallback;

  @override
  _DayContainerState createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
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

  final Map<int, String> intToWeekday = {
    1: 'M',
    2: 'T',
    3: 'W',
    4: 'T',
    5: 'F',
    6: 'S',
    0: 'S',
  };

  void showFlutterToast(String toastMsg) {
//    print('hello world');
    Fluttertoast.showToast(
        msg: toastMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    int todayWeekday = widget.today.weekday % 7;

    Date inputDay = Date(
        widget.today.add(Duration(days: widget.inputWeekday - todayWeekday)));
    print('selectedDay is ${TaskScreen.selectedDay}\ninputDay is $inputDay');

    print('check ${Date(widget.today).toString()}');

    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
//            intToWeekday[widget.today
//                .add(Duration(days: widget.inputWeekday - todayWeekday))
//                .weekday],
            intToWeekday[widget.inputWeekday],
            style: TextStyle(
//                    color: widget.today
//                                .add(Duration(
//                                    days: widget.inputWeekday - todayWeekday))
//                                .weekday ==
//                            3
//                        ? kLightBlueAccent
//                        : Colors.white,
//            color: TaskScreen.selectedDay.dateCompare(inputDay)
//                ? Colors.white
//                : kLightBlueAccent,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showFlutterToast(widget.today
                .add(Duration(days: widget.inputWeekday - todayWeekday))
                .toString());
            TaskScreen.selectedDay = inputDay;
            widget.setStateCallback();
//            print(today.add(Duration(days: inputWeekday - todayWeekday + 1)));
          },
          child: Container(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 5.0,
              left: SizeConfig.blockSizeHorizontal * 1.2,
              right: SizeConfig.blockSizeHorizontal * 1.2,
            ),
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
//              color: weekdayColor[widget.today
//                  .add(Duration(days: widget.inputWeekday - todayWeekday))
//                  .weekday],
              color: TaskScreen.selectedDay.dateCompare(inputDay)
                  ? Colors.white
                  : kLightBlueAccent.withOpacity(0.0),

//            color: kLightBlueAccent,
//        color: diff == 0 ? Color(0xffe3681b) : Color(0xff585866),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: <Widget>[
//                Text(
//                  intToMonth[widget.today
//                      .add(Duration(days: widget.inputWeekday - todayWeekday))
//                      .month],
//                  style: TextStyle(
////                      color: widget.today
////                                  .add(Duration(
////                                      days: widget.inputWeekday - todayWeekday))
////                                  .weekday ==
////                              3
////                          ? kLightBlueAccent
////                          : Colors.white,
//                      color: TaskScreen.selectedDay.dateCompare(inputDay)
//                          ? kLightBlueAccent
//                          : Colors.white,
////                color: Colors.white,
//                      fontWeight: FontWeight.w300,
//                      fontSize: SizeConfig.blockSizeVertical * 2.3),
//                ),
                Text(
//                  widget.today
//                      .add(Duration(
//                          days: widget.inputWeekday - widget.today.weekday))
//                      .day
//                      .toString(),
                  Date(DateTime.now()).dateCompare(inputDay)
                      ? 'Today'
                      : inputDay.day.toString(),
                  style: TextStyle(
//                    color: widget.today
//                                .add(Duration(
//                                    days: widget.inputWeekday - todayWeekday))
//                                .weekday ==
//                            3
//                        ? kLightBlueAccent
//                        : Colors.white,
                    color: TaskScreen.selectedDay.dateCompare(inputDay)
                        ? kBlue
                        : Colors.white.withOpacity(0.5),
//              color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockSizeVertical * 4,
                  ),
                ),
//                Text(
//                  intToWeekday[widget.today
//                      .add(Duration(days: widget.inputWeekday - todayWeekday))
//                      .weekday],
//                  style: TextStyle(
////                    color: widget.today
////                                .add(Duration(
////                                    days: widget.inputWeekday - todayWeekday))
////                                .weekday ==
////                            3
////                        ? kLightBlueAccent
////                        : Colors.white,
//                    color: TaskScreen.selectedDay.dateCompare(inputDay)
//                        ? Colors.white
//                        : kLightBlueAccent,
////              color: Colors.white,
//                    fontWeight: FontWeight.w900,
//                  ),
//                )
              ],
            ),
          ),
        ),
//        TaskScreen.selectedDay.dateCompare(inputDay)
//            ? Icon(
//                Icons.arrow_drop_up,
//                color: kRallyGreen,
//              )
//            : Icon(null),
      ],
    );
  }
}

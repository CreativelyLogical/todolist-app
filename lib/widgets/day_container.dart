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
    1: 'MON',
    2: 'TUE',
    3: 'WED',
    4: 'THU',
    5: 'FRI',
    6: 'SAT',
    0: 'SUN',
  };

//  void showFlutterToast(String toastMsg) {
////    print('hello world');
//    Fluttertoast.showToast(
//        msg: toastMsg,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIos: 1,
//        backgroundColor: Colors.red,
//        textColor: Colors.white,
//        fontSize: 16.0);
//  }

  Color dayColor(Date selectedDay, Date inputDay) {
    // For the DayContainer that IS selected
    if (selectedDay.dateCompare(inputDay)) {
      return kBlue;
    } else {
      // For the DayContainers that aren't selected
      if (inputDay.dateCompare(Date(DateTime.now()))) {
        // If the DayContainer is today
        return Colors.white;
      } else {
        return Colors.white.withOpacity(0.5);
      }
    }
  }

  TextStyle dayTextStyle(Date selectedDay, Date inputDay) {
    return TextStyle(
      color: dayColor(selectedDay, inputDay),
      fontSize: SizeConfig.blockSizeVertical * 3,
      fontWeight: inputDay.dateCompare(Date(DateTime.now()))
          ? FontWeight.w600
          : FontWeight.w500,
    );
  }

  @override
  Widget build(BuildContext context) {
    int todayWeekday = widget.today.weekday % 7;

    Date inputDay = Date(
        widget.today.add(Duration(days: widget.inputWeekday - todayWeekday)));
//    print('selectedDay is ${TaskScreen.selectedDay}\ninputDay is $inputDay');
//
//    print('check ${Date(widget.today).toString()}');

    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
//      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              intToWeekday[widget.inputWeekday],
              style: TextStyle(
                color: inputDay.dateCompare(Date(DateTime.now()))
                    ? kWhite
                    : kWhite.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
//              showFlutterToast(widget.today
//                  .add(Duration(days: widget.inputWeekday - todayWeekday))
//                  .toString());
              TaskScreen.selectedDay = inputDay;
              widget.setStateCallback();
//            print(today.add(Duration(days: inputWeekday - todayWeekday + 1)));
            },
            child: CircleAvatar(
              backgroundColor: TaskScreen.selectedDay.dateCompare(inputDay)
                  ? Colors.white
                  : kLightBlueAccent.withOpacity(0.0),
              radius: SizeConfig.blockSizeVertical * 2.5,
//              padding: EdgeInsets.all(10),
//              padding: EdgeInsets.only(
//                top: 10.0,
//                bottom: 5.0,
////                left: SizeConfig.blockSizeHorizontal * 1.2,
////                right: SizeConfig.blockSizeHorizontal * 1.2,

//              margin: EdgeInsets.symmetric(horizontal: 5.0),
//              decoration: BoxDecoration(
//                shape: BoxShape.circle,
////              color: weekdayColor[widget.today
////                  .add(Duration(days: widget.inputWeekday - todayWeekday))
////                  .weekday],
//                color: TaskScreen.selectedDay.dateCompare(inputDay)
//                    ? Colors.white
//                    : kLightBlueAccent.withOpacity(0.0),
//
////            color: kLightBlueAccent,
////        color: diff == 0 ? Color(0xffe3681b) : Color(0xff585866),
////                borderRadius: BorderRadius.all(Radius.circular(10.0)),
//              ),
              child: Text(
//                  widget.today
//                      .add(Duration(
//                          days: widget.inputWeekday - widget.today.weekday))
//                      .day
//                      .toString(),
                inputDay.day.toString(),
                style: dayTextStyle(TaskScreen.selectedDay, inputDay),
//                    style: TextStyle(
//                      color: dayColor(TaskScreen.selectedDay, inputDay),
////                      color: TaskScreen.selectedDay.dateCompare(inputDay)
////                          ? kBlue
////                          : Colors.white.withOpacity(0.5),
////              color: Colors.white,
//                      fontWeight: FontWeight.w500,
//                      fontSize: SizeConfig.blockSizeVertical * 4,
//                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

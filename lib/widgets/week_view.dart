import 'package:flutter/material.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/screens/task_screen.dart';
import 'day_container.dart';
import 'package:my_todo/constants.dart';

class WeekView extends StatelessWidget {
  WeekView({this.setStateCallback});

  final Function setStateCallback;

  var days = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff007ed4),
            const Color(0xff1a8ddb),
            const Color(0xff3ba5ed),
          ],
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)),
      ),
      child: Column(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
//                    top: SizeConfig.screenHeight * 0.035,
                    bottom: SizeConfig.screenHeight * 0.015,
//                    left: SizeConfig.screenWidth * 0.05,
                  ),
                  child: Text(
                    '${TaskScreen.selectedDay.month} ${TaskScreen.selectedDay.year}',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: SizeConfig.blockSizeVertical * 4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
//            height: SizeConfig.screenHeight * 0.115,
            child: Row(
//              scrollDirection: Axis.horizontal,
//              shrinkWrap: false,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DayContainer(
                  today: DateTime.now(),
                  inputWeekday: 0,
                  setStateCallback: setStateCallback,
                ),
                DayContainer(
                  today: DateTime.now(),
                  inputWeekday: 1,
                  setStateCallback: setStateCallback,
                ),
                DayContainer(
                  today: DateTime.now(),
                  inputWeekday: 2,
                  setStateCallback: setStateCallback,
                ),
                DayContainer(
                  today: DateTime.now(),
                  inputWeekday: 3,
                  setStateCallback: setStateCallback,
                ),
                DayContainer(
                  today: DateTime.now(),
                  inputWeekday: 4,
                  setStateCallback: setStateCallback,
                ),
                DayContainer(
                  today: DateTime.now(),
                  inputWeekday: 5,
                  setStateCallback: setStateCallback,
                ),
                DayContainer(
                  today: DateTime.now(),
                  inputWeekday: 6,
                  setStateCallback: setStateCallback,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

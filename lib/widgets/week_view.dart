import 'package:flutter/material.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/screens/task_screen.dart';
import 'day_container.dart';
import 'package:my_todo/constants.dart';

class WeekView extends StatelessWidget {
  WeekView({this.setStateCallback});

  final Function setStateCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.04),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)),
      ),
      child: Column(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: kWhite,
                ),
              ),
//              Expanded(
//                child: Align(
//                  alignment: Alignment.center,
//                  child: Text(
//                    TaskScreen.selectedDay.month,
//                    style: TextStyle(
//                      color: kWhite,
//                      fontSize: 30.0,
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              )
            ],
          ),
          Row(
            children: <Widget>[
//              Expanded(
//                child: Padding(
//                  padding: EdgeInsets.only(
////                    top: SizeConfig.screenHeight * 0.035,
//                    bottom: 5,
//                  ),
//                  child: Text(
//                    TaskScreen.selectedDay.month,
//                    style: TextStyle(
//                      color: kWhite,
//                      fontSize: 30.0,
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
//                      left: SizeConfig.screenWidth * 0.05,
//                      bottom: SizeConfig.screenHeight * 0.015,
                ),
            child: SizedBox(
              height: SizeConfig.screenHeight * 0.125,
              child: Container(
//                          color: kLightBlueAccent,
//                    margin: EdgeInsets.only(bottom: 10.0),
//                    padding: EdgeInsets.only(bottom: 15.0),
                  child: ListView(
                scrollDirection: Axis.horizontal,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  padding: EdgeInsets.only(bottom: 20),
//                        scrollDirection: Axis.horizontal,
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
              )),
            ),
          ),
        ],
      ),
    );
  }
}

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              IconButton(
//                padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.05),
//                icon: Icon(
//                  Icons.menu,
//                  color: kWhite,
//                  size: SizeConfig.blockSizeVertical * 4,
//                ),
//              ),
//              IconButton(
//                padding: EdgeInsets.only(right: SizeConfig.screenWidth * 0.05),
//                icon: Icon(
//                  Icons.settings,
//                  color: kWhite,
//                  size: SizeConfig.blockSizeVertical * 4,
//                ),
//              ),
//            ],
//          ),
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
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.125,
            child: Container(
                alignment: Alignment.center,
//                          color: kLightBlueAccent,
//                    margin: EdgeInsets.only(bottom: 10.0),
//                    padding: EdgeInsets.only(bottom: 15.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  padding: EdgeInsets.only(bottom: 20),
//                        scrollDirection: Axis.horizontal,
                  child: Row(
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
                )),
          ),
        ],
      ),
    );
  }
}

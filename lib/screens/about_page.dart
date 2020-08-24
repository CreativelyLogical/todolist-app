import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'all_tasks_screen.dart';
import 'task_screen.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
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
                      color: kWhite.withOpacity(0.5),
                    ),
                    iconSize: SizeConfig.screenHeight * 0.045,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskScreen()));
                    },
                  ),
                  Text(
                    'Tasks',
                    style: TextStyle(
                        color: kWhite.withOpacity(0.6),
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
                      color: kWhite,
                    ),
                    iconSize: SizeConfig.screenHeight * 0.045,
                    onPressed: () {
                      print('You are already at the Abouts Screen');
                    },
//                color: kWhite,
                  ),
                  Text(
                    'About',
                    style: TextStyle(
                        color: kWhite,
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
      body: SafeArea(
        child: Container(
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.screenHeight * 0.01),
                child: Text(
                  'About',
                  style: TextStyle(
                    color: kBlue,
                    fontSize: SizeConfig.blockSizeVertical * 4.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

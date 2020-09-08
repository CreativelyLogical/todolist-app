import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';
import 'all_tasks_screen.dart';
import 'task_screen.dart';
import 'package:my_todo/main.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('back button has been pressed');
        for (var i = 0; i < MyApp.pagesOnStack; i++) {
          SystemNavigator.pop();
        }
        return Future.value(true);
      },
      child: Scaffold(
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
                        MyApp.pagesOnStack++;
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
                        MyApp.pagesOnStack++;
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
//            width: SizeConfig.screenWidth,
            child: ListView(
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
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.04),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          'Hi, this is Umutjan, creator of the Hope todo-list. Thank you for using my app. It is my hope that '
                          'this app will prove useful to you and in the very least, help you stay on top of your tasks'
                          ' and responsibilities. \n\nPlease forgive the apparent lack of features of this app, since this is the very'
                          ' first version of Hope, I am hoping (pun-intended) to add more features in my spare time, which is unfortunately'
                          ' hard to come by since I am still in university.'
                          '\n\nIn the meanwhile, '
                          'if you are enjoying the app, '
                          'please give it a rating. If not, please leave a review'
                          ' containing suggestions on how it can be improved.',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.5,
                          ),
                        ),
//                        Padding(
//                          padding: EdgeInsets.only(
//                            top: SizeConfig.screenHeight * 0.05,
//                            bottom: SizeConfig.screenHeight * 0.01,
//                          ),
//                          child: Text(
//                            "Here's to a more productive life!",
//                            style: TextStyle(
//                              fontSize: SizeConfig.blockSizeVertical * 2.5,
//                            ),
//                            textAlign: TextAlign.center,
//                          ),
//                        ),
//                        Text(
////                          '🍻',
////                          style: TextStyle(
////                            fontSize: SizeConfig.blockSizeVertical * 4,
////                          ),
////                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenHeight * 0.1,
                          ),
                          child: Image.asset(
                            'assets/images/app-logo.png',
                            width: SizeConfig.screenWidth * 0.6,
                            height: SizeConfig.screenHeight * 0.1,
                          ),
                        ),
                        Text(
                          "Version: 1.0.0",
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 3.5,
                            color: kBlue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

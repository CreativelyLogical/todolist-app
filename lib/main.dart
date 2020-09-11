import 'package:flutter/material.dart';
import 'screens/task_screen.dart';
import 'package:provider/provider.dart';
import 'models/task_data_holder.dart';
import 'size_config.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:my_todo/notifications/todo_notifications.dart';
import 'dart:io';

Future<void> main() async {
//  await TodoNotifications().init();

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();

  static var pagesOnStack = 0;
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
//    _requestIOSPermissions();
//    _configureDidReceiveLocalNotificationSubject();
//    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Rubik',
          bottomAppBarColor: kBlue,
        ),
        title: 'Hope',
        home: Scaffold(
          body: TaskScreen(),
        ),
      ),
    );
  }
}

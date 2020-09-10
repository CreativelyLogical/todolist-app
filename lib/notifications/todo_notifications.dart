import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:my_todo/constants.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class TodoNotifications {
  Future<void> init() async {
    final MethodChannel platform =
        MethodChannel('crossingthestreams.io/resourceResolver');

    WidgetsFlutterBinding.ensureInitialized();

    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  Future<void> _scheduleNotification({
    DateTime notificationTime,
    String title,
    String body,
    int id,
  }) async {
    Duration untilNotification = notificationTime.difference(DateTime.now());
    var scheduledNotificationDateTime = DateTime.now().add(untilNotification);
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'Reminders',
      'Reminders notification channel',
      icon: 'notification_small',
      priority: Priority.High,
      importance: Importance.Max,
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      largeIcon: DrawableResourceAndroidBitmap('notification_large'),
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: Colors.blue.shade900,
//        ledColor: const Color.fromARGB(255, 255, 0, 0),
//        ledOnMs: 1000,
//        ledOffMs: 500,
    );
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      body,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  Future<void> schedule({
    String notificationTitle,
    String notificationBody,
    int notificationId,
    DateTime dateTime,
  }) async {
//    print('the notification id of $notificationTitle was $notificationId');
    if (dateTime.isAfter(DateTime.now())) {
      await _scheduleNotification(
          title: notificationTitle,
          body: notificationBody,
          id: notificationId,
          notificationTime: dateTime);
    }
  }

  Future<void> cancelNotificationById(int id) async {
//    print('for deletion, the notification id is $id');
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

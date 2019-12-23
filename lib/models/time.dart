import 'package:flutter/material.dart';

class Time {
  Time(TimeOfDay timeOfDay, BuildContext context) {
    this.time = timeOfDay;
    this.context = context;
    setTime();
  }

  TimeOfDay time;
  BuildContext context;

  String hour;
  String minute;

  void setTime() {
    hour = time.hour.toString();
    minute = time.minute.toString();
  }

  String toString() {
    return time.format(context);
  }
}

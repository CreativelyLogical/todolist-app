class Date {
  DateTime dateTime;
  String month;
  int day;
  int year;
  String weekday;

  static final Map<int, String> intToMonth = {
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

  static final Map<int, String> intToWeekday = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
  };

  @override
  Date(DateTime dateTime) {
    this.dateTime = dateTime;
    setDate();
  }

  void setDate() {
    month = intToMonth[dateTime.month];
    day = dateTime.day;
    year = dateTime.year;
    weekday = intToWeekday[dateTime.weekday];
  }

  bool dateCompare(Date inputDate) {
    if (this.month == inputDate.month &&
        this.day == inputDate.day &&
        this.year == inputDate.year) {
      return true;
    } else {
      return false;
    }
  }

  DateTime getDateTime() {
    return dateTime;
  }

  String toString() {
    return '$weekday, $month $day';
  }

  String toStringSQL() {
    print(dateTime.toString().substring(0, 10));
    return dateTime.toString().substring(0, 10);
  }
}

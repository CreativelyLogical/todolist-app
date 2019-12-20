class Date {
  DateTime dateTime;
  String month;
  int day;
  int year;

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

  @override
  Date(DateTime dateTime) {
    this.dateTime = dateTime;
    setDate();
  }

  void setDate() {
    month = intToMonth[dateTime.month];
    day = dateTime.day;
    year = dateTime.year;
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

  String toString() {
    return '$month $day, $year';
  }

  String toStringSQL() {
    print(dateTime.toString().substring(0, 10));
    return dateTime.toString().substring(0, 10);
  }
}

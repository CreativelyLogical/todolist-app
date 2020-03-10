import 'package:flutter/material.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/constants.dart';
import 'task_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;

  Map<DateTime, List<Event>> _events;

  DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars;
  List<Calendar> get _writableCalendars =>
      _calendars?.where((c) => !c.isReadOnly)?.toList() ?? List<Calendar>();

  List<Calendar> get _readOnlyCalendars =>
      _calendars?.where((c) => c.isReadOnly)?.toList() ?? List<Calendar>();

  List<List<Event>> _allCalendarEvents;

  _CalendarScreenState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  int iteration = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
    _allCalendarEvents = List<List<Event>>();
    _retrieveCalendars();
    Future.delayed(Duration(seconds: 1));
    _events = Map();
//    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
//    print('there are ${_allCalendarEvents?.length} events in total');
//    print('the calendar events are ${_allCalendarEvents[2][0].title}');
    try {
      iteration += 1;
      for (int i = 0; i < _calendars?.length; i++) {
        Calendar calendar = _calendars[i];
        _retrieveCalendarEvents(calendar);
      }
    } catch (e) {
      print('ok so the error is $e');
    }
    print('now we will display all the events of the calendar');
    try {
      for (int i = 0; i < _calendars.length; i++) {
        print('printing the events of ${_calendars[i].name}...');
        for (Event event in _allCalendarEvents[i]) {
          print('the event is ${event.title} and it starts on ${event.start}');
        }
      }
    } catch (e) {
      print('ok now the error is $e');
    }

    try {
      if (_calendars?.length != 0 && _allCalendarEvents?.length != 0) {
        for (int i = 0; i < _calendars?.length; i++) {
          for (Event event in _allCalendarEvents[i]) {
            DateTime eventStart = event.start;
            int startYear = eventStart.year;
            int startMonth = eventStart.month;
            int startDay = eventStart.day;
            DateTime eventStartDate = DateTime(startYear, startMonth, startDay);
            if (_events[eventStartDate] == null) {
              _events[eventStartDate] = new List<Event>.of([event]);
            } else {
              _events[eventStartDate].add(event);
            }
          }
        }
      }
    } catch (e) {
      print('the error is $e');
    }
    print('finally, _event is $_events');
    print('and now lets print the _events...');
    try {
      _events.forEach((date, eventList) {
        for (Event event in eventList) {
          print('${event.start} : ${event.title}');
        }
      });
    } catch (e) {
      print('and now the error is $e');
    }

    SizeConfig().init(context);
//    print('there are ${_calendars.length} calendars here');
    return Scaffold(
      backgroundColor: kBlue,
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
//                  crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(0),
//                      padding: EdgeInsets.only(
//                          left: SizeConfig.blockSizeHorizontal * 10),
                    icon: Icon(
                      Icons.date_range,
                      color: kWhite,
                    ),
                    iconSize: SizeConfig.screenHeight * 0.045,
                    onPressed: () {
                      print('we are already here');
                    },

//                color: kWhite,
                  ),
                  Text(
                    'Calendar',
                    style: TextStyle(
                        color: kWhite,
                        fontSize: SizeConfig.screenHeight * 0.02),
                    textAlign: TextAlign.start,
                  )
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
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'All tasks',
                    style: TextStyle(
                        color: kWhite.withOpacity(0.5),
                        fontSize: SizeConfig.screenHeight * 0.02),
                  )
                ],
              ),
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
                    'Week View',
                    style: TextStyle(
                        color: kWhite.withOpacity(0.6),
                        fontSize: SizeConfig.screenHeight * 0.02),
                  ),
                ],
              )
            ],
          ),
        ),
//          child: Padding(padding: EdgeInsets.only(bottom: 0.5)),
//          notchMargin: 10.0,
//          child: Padding(padding: EdgeInsets.all(20.0)),
        shape: CircularNotchedRectangle(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.05),
        child: Container(
          child: Column(
            children: <Widget>[
              TableCalendar(
                events: _events,
                calendarController: _calendarController,
                calendarStyle: CalendarStyle(
                  highlightToday: true,
                  selectedColor: kWhite,
                  todayColor: kBlue,
                  todayStyle: kCalendarTodayStyle,
                  weekdayStyle: kCalendarWeekdayStyle,
                  weekendStyle: kCalendarWeekendStyle,
                  markersColor: Colors.red,
                  outsideWeekendStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.yellow.withOpacity(0.6),
                  ),
                  outsideStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: kWhite.withOpacity(0.5),
                  ),
                ),
                builders: CalendarBuilders(
                  selectedDayBuilder:
                      (BuildContext context, DateTime date, List events) =>
                          Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: kCalendarSelectedDayStyle,
                    ),
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w600,
                  ),
                  weekdayStyle: TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                      color: kWhite,
                      fontSize: 19,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: kWhite,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: kWhite,
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: kWhite,
                    ),
                    formatButtonDecoration: BoxDecoration(
                        border: Border.all(
                          color: kWhite,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ))),
                onDaySelected: (DateTime day, List events) {
                  print('day selected is $day');
                },
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult?.data;
        print('so the calendars are $_calendars');
        print('there are ${_calendars.length} calendars then');
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future _retrieveCalendarEvents(Calendar calendar) async {
    final startDate = DateTime.now().add(Duration(days: -30));
    final endDate = DateTime.now().add(Duration(days: 30));
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(startDate: startDate, endDate: endDate));
    if (iteration <= 2) {
      setState(() {
//      _calendarEvents = calendarEventsResult?.data;
        _allCalendarEvents.add(calendarEventsResult?.data);
        print(
            'so now there are ${_allCalendarEvents?.length} event lists in total');
//      _isLoading = false;
      });
    }
  }
}

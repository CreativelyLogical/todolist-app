import 'package:flutter/material.dart';
import 'task_screen.dart';
import 'all_tasks_screen.dart';
import 'overview_screen.dart';
import 'about_page.dart';
import 'package:my_todo/constants.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  var _screens = [
    OverviewScreen(),
    TaskScreen(),
    AllTasksScreen(),
    AboutPage(),
  ];

  int _currentIndex = 0;
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _screens,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff007ed4),
              const Color(0xff1a8ddb),
              const Color(0xff3ba5ed),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
//        borderRadius: BorderRadius.only(
//          bottomLeft: Radius.circular(15.0),
//          bottomRight: Radius.circular(15.0),
//        ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              pageController.animateToPage(
                _currentIndex,
                duration: Duration(
                  milliseconds: 200,
                ),
                curve: Curves.linear,
              );
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: kWhite.withOpacity(0.6),
          elevation: 0.0,
          items: [
            Icons.dashboard,
            Icons.view_week,
            Icons.format_list_bulleted,
            Icons.info,
          ]
              .asMap()
              .map(
                (key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    title: Text(''),
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _currentIndex == key ? kWhite : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}

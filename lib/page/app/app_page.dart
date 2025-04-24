import 'package:flutter/material.dart';
import 'package:project_medi/page/app/calendar_page.dart';
import 'package:project_medi/page/app/my_page.dart';
import 'package:project_medi/page/app/search.dart';
import 'package:project_medi/page/app/timer_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<String> _titles = ['검색', '타이머', '캘린더', '프로필'];
  final List<Widget> _pages = [
    SearchPage(),
    TimerPage(),
    CalendarPage(),
    MyPage(),
  ];
  final List<Icon> _icons = [
    Icon(Icons.search),
    Icon(Icons.timer),
    Icon(Icons.calendar_month),
    Icon(Icons.person),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff35ABFF),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: List.generate(
          _titles.length,
          (index) => BottomNavigationBarItem(
            icon: _icons[index],
            label: _titles[index],
          ),
        ),
      ),
    );
  }
}

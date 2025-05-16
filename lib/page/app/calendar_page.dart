import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(
            '캘린더',
            style: TextStyle(fontSize: 25, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

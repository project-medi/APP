import 'package:flutter/material.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(
            '타이머',
            style: TextStyle(fontSize: 25, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

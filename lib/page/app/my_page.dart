import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(
            '프로필',
            style: TextStyle(fontSize: 25, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

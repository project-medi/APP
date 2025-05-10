import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            child: const Text(
              '로그아웃',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

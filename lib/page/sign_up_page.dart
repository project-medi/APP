import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 180),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '회원가입',
                style: TextStyle(
                  fontFamily: 'AppleSDGothicNeo',
                  fontSize: 38,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

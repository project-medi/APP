import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_medi/page/app/app_page.dart';
import 'package:project_medi/page/login/login_page.dart';

class StartSplashPage extends StatelessWidget {
  const StartSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 빌드가 완료된 후에 checkUserStatus를 호출하여 화면 전환을 처리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserStatus(context);
    });

    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.black)),
    );
  }
}

void checkUserStatus(BuildContext context) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // 사용자가 로그인한 상태
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AppPage()),
    );
  } else {
    // 사용자가 로그인하지 않은 상태
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

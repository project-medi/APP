import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_medi/page/login/login_page.dart';

class RegisterSplashPage extends StatelessWidget {
  const RegisterSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/mail.svg'),
            Text('등록하신 이메일로', style: TextStyle(color: Color(0xff707070))),
            Text('인증 메일을 발송했습니다.', style: TextStyle(color: Color(0xff707070))),
            Text(
              '이메일을 확인 후 로그인해주세요.',
              style: TextStyle(color: Color(0xff707070)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '로그인 화면으로 이동',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

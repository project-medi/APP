import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_medi/page/app/app_page.dart';
import 'package:project_medi/page/login/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  bool _obscurePassword = true;

  Future<void> _login(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => _errorMessage = null); // 로그인 성공 시 에러 초기화

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => AppPage()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            _errorMessage = '등록된 이메일이 없습니다.';
            break;
          case 'wrong-password':
            _errorMessage = '비밀번호가 일치하지 않습니다.';
            break;
          default:
            _errorMessage = '오류가 발생했습니다. 다시 시도해주세요.';
        }
      });
    }
  }

  Widget toggleObscurePassword() {
    return IconButton(
      icon: SvgPicture.asset(
        _obscurePassword
            ? 'assets/images/password_confirm_off.svg'
            : 'assets/images/password_confirm_on.svg',
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 120),
                      const Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          '이메일',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Color(0xffAEAEAE),
                        decoration: const InputDecoration(
                          hintText: '이메일을 입력해주세요',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffAEAEAE)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          '비밀번호',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        cursorColor: Color(0xffAEAEAE),
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력해주세요',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: const OutlineInputBorder(),
                          suffixIcon: toggleObscurePassword(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffAEAEAE)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_errorMessage != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // 비밀번호 찾기 기능
                          },
                          child: const Text(
                            '비밀번호 찾기',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '아직 회원가입을 하지 않았다면?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffBDBDBD),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          '회원가입하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7A7A7A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

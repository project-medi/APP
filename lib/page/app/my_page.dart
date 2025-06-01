import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_medi/page/app/edit_my_page.dart';
import 'package:project_medi/page/login/login_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Stream<DocumentSnapshot> getUserData(String uid) {
    return FirebaseFirestore.instance
        .collection('medi')
        .doc('user')
        .collection('user')
        .doc(uid)
        .snapshots();
  }

  Widget UserDataUnit(BuildContext context, String title, Widget data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: Color(0xff707070),
            ),
          ),
          SizedBox(height: 8),
          data,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Center(child: Text('프로필')),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: getUserData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            });
            return const SizedBox.shrink();
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          if ((userData['name'] ?? '').toString().isEmpty ||
              (userData['phoneNumber'] ?? '').toString().isEmpty ||
              (userData['year'] ?? '').toString().isEmpty ||
              (userData['month'] ?? '').toString().isEmpty ||
              (userData['day'] ?? '').toString().isEmpty ||
              (userData['weight'] ?? '').toString().isEmpty ||
              (userData['note'] ?? '').toString().isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const EditMypage()),
              );
            });
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 29,
                right: 29,
                top: 16,
                bottom: 29,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditMypage(),
                            ),
                          );
                        },
                        child: const Text(
                          '재설정',
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: UserDataUnit(
                              context,
                              '이름',
                              Text(
                                userData['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          IntrinsicWidth(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: UserDataUnit(
                                context,
                                '전화번호',
                                Text(
                                  userData['phoneNumber'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          UserDataUnit(
                            context,
                            '생년월일',
                            Row(
                              children: [
                                birth(
                                  userData: userData,
                                  start: 'year',
                                  ending: '년도 ',
                                ),
                                SizedBox(width: 12),
                                birth(
                                  userData: userData,
                                  start: 'month',
                                  ending: '월 ',
                                ),
                                SizedBox(width: 12),
                                birth(
                                  userData: userData,
                                  start: 'day',
                                  ending: '일 ',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          IntrinsicWidth(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: UserDataUnit(
                                context,
                                '몸무게',
                                Row(
                                  children: [
                                    Text(
                                      userData['weight'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Text(
                                      ' kg',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(bottom: 1),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: UserDataUnit(
                              context,
                              '특이사항',
                              Text(
                                userData['note'] ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '*위 정보들은 119 구급대원님들에게 제공됩니다',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () => logout(context),
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class birth extends StatelessWidget {
  const birth({
    super.key,
    required this.userData,
    required this.ending,
    required this.start,
  });

  final Map<String, dynamic> userData;
  final String ending;
  final String start;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Row(
          children: [
            Text(
              '${userData[start] ?? ''} ',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Text(
              ending,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff707070),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

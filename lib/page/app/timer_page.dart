import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_medi/page/app/edit_timer_page.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  Future<List<Map<String, dynamic>>> fetchTimers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot =
        await FirebaseFirestore.instance
            .collection('medi')
            .doc('user')
            .collection('user')
            .doc(user.uid)
            .collection('timers')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text('복용 일정')),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTimers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final timers = snapshot.data ?? [];

          if (timers.isEmpty) {
            return _buildEmptyView(context);
          } else {
            return _buildTimerList(timers);
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditTimerPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF23A3FF),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('복용 일정 추가', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '설정된 타이머가 없습니다.',
          style: TextStyle(fontSize: 24, color: Colors.black54),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditTimerPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[400],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('타이머 추가', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildTimerList(List<Map<String, dynamic>> timers) {
    return ListView.builder(
      itemCount: timers.length,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      itemBuilder: (context, index) {
        final timer = timers[index];
        final name = timer['name'] ?? '이름 없음';
        final medicines =
            (timer['medicines'] as List?)?.join(', ') ?? '약 정보 없음';
        final startDate = timer['startDate']?.split(' ')[0] ?? '';
        final endDate = timer['endDate']?.split(' ')[0] ?? '';
        final alarmTimes = (timer['alarmTimes'] as List?)?.cast<String>() ?? [];
        final memo = timer['memo'] ?? '';

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('약 목록: $medicines'),
                const SizedBox(height: 4),
                Text('복용기간: $startDate ~ $endDate'),
                const SizedBox(height: 4),
                const Text('알람시간:'),
                ...alarmTimes.map(
                  (time) => Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text('• $time'),
                  ),
                ),
                const Divider(height: 20),
                Text('메모내용: $memo'),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: 재설정 기능 추가
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
              ],
            ),
          ),
        );
      },
    );
  }
}

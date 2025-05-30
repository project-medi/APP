import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_medi/page/app/edit_timer_page.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.requestExactAlarmsPermission();

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _scheduleAlarm(String time, int id, String title) async {
    final parts = time.replaceAll(RegExp(r'[^0-9]'), ' ').trim().split(' ');
    if (parts.length < 3) return;
    final hour = int.tryParse(parts[1]) ?? 0;
    final minute = int.tryParse(parts[2]) ?? 0;
    final isAm = parts[0] == '오전';
    final now = DateTime.now();

    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      isAm ? hour : (hour == 12 ? 12 : hour + 12),
      minute,
    );

    var scheduleTZ = tz.TZDateTime.from(scheduledDate, tz.local);

    if (scheduleTZ.isBefore(DateTime.now())) {
      scheduleTZ = scheduleTZ.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      '$title 복용 시간',
      '약 복용 알람 시간입니다.',
      scheduleTZ,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel_id',
          '알람 채널',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

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

    final timers = snapshot.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < timers.length; i++) {
      final timer = timers[i];
      final name = timer['name'] ?? '약';
      final alarmTimes = (timer['alarmTimes'] as List?)?.cast<String>() ?? [];
      for (int j = 0; j < alarmTimes.length; j++) {
        _scheduleAlarm(alarmTimes[j], i * 100 + j, name);
      }
    }

    return timers;
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
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchTimers(),
          builder: (context, snapshot) {
            if (!_isMounted) return const SizedBox();
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xffEAEAEA)),
              color: Colors.white,
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
                  Text(
                    '약 목록: $medicines',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '복용기간: $startDate ~ $endDate',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '알람시간:',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ...alarmTimes.map(
                    (time) => Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        '• $time',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 20),
                  Text(
                    '메모내용: $memo',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditTimerPage(),
                          ),
                        );
                      },
                      child: const Text(
                        '재설정',
                        style: TextStyle(
                          color: Color(0xffC5C5C5),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xff707070),
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
    );
  }
}

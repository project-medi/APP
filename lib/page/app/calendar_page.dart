import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  final Map<String, List<DateTime>> _dateGroups = {};
  final Map<String, bool> _buttonStates = {};

  @override
  void initState() {
    super.initState();
    fetchTimersFromFirestore();
  }

  Future<void> fetchTimersFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('medi')
            .doc('user')
            .collection('user')
            .doc(user.uid)
            .collection('timers')
            .get();

    final dateGroups = <String, List<DateTime>>{};
    final buttonStates = <String, bool>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final name = data['name'] ?? '이름 없음';
      final start = DateTime.tryParse(data['startDate'] ?? '');
      final end = DateTime.tryParse(data['endDate'] ?? '');
      if (start == null || end == null) continue;

      final dates = <DateTime>[];
      DateTime current = start;
      while (!current.isAfter(end)) {
        dates.add(current);
        current = current.add(const Duration(days: 1));
      }
      dateGroups[name] = dates;
      buttonStates[name] = false;
    }

    setState(() {
      _dateGroups.clear();
      _dateGroups.addAll(dateGroups);
      _buttonStates.clear();
      _buttonStates.addAll(buttonStates);
    });
  }

  void _selectGroup(String label) {
    final dates = _dateGroups[label]!;
    dates.sort();
    final alreadySelected =
        _rangeStart == dates.first && _rangeEnd == dates.last;

    setState(() {
      if (alreadySelected) {
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _buttonStates[label] = false;
      } else {
        _rangeStart = dates.first;
        _rangeEnd = dates.last;
        _rangeSelectionMode = RangeSelectionMode.toggledOn;
        _buttonStates.updateAll((_, __) => false);
        _buttonStates[label] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              buildCustomHeader(),
              buildCalendar(),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '약 복용기간이 궁금하다면',
                  style: TextStyle(
                    color: Color(0xff292929),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '복용 일정을 클릭하세요',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ..._buttonStates.keys.map(
                (label) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: buildToggleButton(label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
            });
          },
        ),
        Text(
          '${_focusedDay.year}년 ${_focusedDay.month}월 ${_focusedDay.day}일',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
            });
          },
        ),
      ],
    );
  }

  TableCalendar buildCalendar() {
    return TableCalendar(
      locale: 'ko-KR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      rangeSelectionMode: _rangeSelectionMode,
      onDaySelected: (_, __) {},
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _rangeStart = start;
          _rangeEnd = end;
          _focusedDay = focusedDay;
          _rangeSelectionMode = RangeSelectionMode.toggledOn;
        });
      },
      selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
      calendarStyle: CalendarStyle(
        todayDecoration: const BoxDecoration(
          color: Color(0xFF23A3FF),
          shape: BoxShape.circle,
        ),
        rangeHighlightColor: const Color(0xFF23A3FF),
        rangeStartDecoration: const BoxDecoration(
          color: Color(0xFF23A3FF),
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: const BoxDecoration(
          color: Color(0xFF23A3FF),
          shape: BoxShape.circle,
        ),
        withinRangeTextStyle: const TextStyle(color: Colors.white),
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        titleTextStyle: TextStyle(fontSize: 0),
      ),
    );
  }

  Widget buildToggleButton(String label) {
    final isSelected = _buttonStates[label] ?? false;
    return ElevatedButton(
      onPressed: () => _selectGroup(label),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xff23A3FF) : const Color(0xffF8F8F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(double.infinity, 50),
        alignment: Alignment.centerLeft,
        elevation: 2,
        padding: const EdgeInsets.only(left: 18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
        ],
      ),
    );
  }
}

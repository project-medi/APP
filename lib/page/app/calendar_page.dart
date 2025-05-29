import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final Map<String, bool> _buttonStates = {'감기약': false, '진통제': false};

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dateGroups['감기약'] =
        [
          21,
          22,
          23,
          24,
          25,
        ].map((d) => DateTime(today.year, today.month, d)).toList();
    _dateGroups['진통제'] =
        [27, 28, 29].map((d) => DateTime(today.year, today.month, d)).toList();
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
              buildCalendar(),
              SizedBox(height: 20),
              Align(
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
              Align(
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
              buildToggleButton('감기약'),
              const SizedBox(height: 20),
              buildToggleButton('진통제'),
            ],
          ),
        ),
      ),
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

      /// ✅ 선택한 날이 시작과 끝이 같을 때도 꾸며주도록 설정
      selectedDayPredicate: (day) {
        return _rangeStart != null &&
            _rangeEnd != null &&
            _rangeStart == _rangeEnd &&
            isSameDay(day, _rangeStart);
      },

      calendarStyle: CalendarStyle(
        rangeHighlightColor: const Color(0xFF76ABFF),
        withinRangeDecoration: const BoxDecoration(),
        rangeStartTextStyle: const TextStyle(color: Colors.white),
        rangeEndTextStyle: const TextStyle(color: Colors.white),
        withinRangeTextStyle: const TextStyle(color: Colors.white),
        selectedDecoration: const BoxDecoration(),
        todayDecoration: const BoxDecoration(),
        defaultDecoration: const BoxDecoration(),
        outsideDecoration: const BoxDecoration(),
        weekendDecoration: const BoxDecoration(),
        holidayDecoration: const BoxDecoration(),
        disabledDecoration: const BoxDecoration(),
      ),

      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          return Column(
            children: [
              Text(
                '${day.month}월',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                color: const Color(0xffAEAEAE),
                height: 1,
                width: double.infinity,
              ),
            ],
          );
        },

        /// ✅ 단일 선택 시 (rangeStart == rangeEnd) 적용될 스타일
        selectedBuilder: (context, date, _) {
          return Center(
            child: Container(
              width: 36,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF76ABFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },

        todayBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: 36,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF76ABFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },

        rangeStartBuilder: (context, date, _) {
          return Center(
            child: Container(
              width: 36,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF76ABFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },

        rangeEndBuilder: (context, date, _) {
          return Center(
            child: Container(
              width: 36,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF76ABFF),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },

        withinRangeBuilder: (context, date, _) {
          return Center(
            child: Container(
              width: 36,
              height: 34,
              color: const Color(0xFF76ABFF),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
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
        backgroundColor: isSelected ? Colors.blue : const Color(0xffF8F8F8),
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
            IconButton(
              onPressed: () => print('김동현 바보'),
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

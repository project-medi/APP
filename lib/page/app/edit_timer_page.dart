import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EditTimerPage extends StatefulWidget {
  const EditTimerPage({super.key});

  @override
  State<EditTimerPage> createState() => _EditTimerPageState();
}

class _EditTimerPageState extends State<EditTimerPage> {
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _timerNameController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();

  final FixedExtentScrollController hourController =
      FixedExtentScrollController();
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController();
  final FixedExtentScrollController ampmController =
      FixedExtentScrollController();

  final List<String> ampm = ['오전', '오후'];
  List<String> selectedTimes = [];

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();

  bool get isFormValid {
    return _timerNameController.text.isNotEmpty &&
        _medicineNameController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null &&
        selectedTimes.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hourController.jumpToItem(0);
      minuteController.jumpToItem(30);
      ampmController.jumpToItem(0);
    });
    _timerNameController.addListener(() => setState(() {}));
    _medicineNameController.addListener(() => setState(() {}));
    _memoController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _timerNameController.dispose();
    _medicineNameController.dispose();
    _memoController.dispose();
    hourController.dispose();
    minuteController.dispose();
    ampmController.dispose();
    super.dispose();
  }

  int safeSelectedIndex(FixedExtentScrollController controller, int max) {
    try {
      if (!controller.hasClients) return 0;
      final index = controller.selectedItem;
      return (index >= 0 && index < max) ? index : 0;
    } catch (_) {
      return 0;
    }
  }

  int get selectedHour => safeSelectedIndex(hourController, 12) + 1;
  int get selectedMinute => safeSelectedIndex(minuteController, 60);
  String get selectedAmPm =>
      ampm[safeSelectedIndex(ampmController, ampm.length)];

  void updateSelectedTime() {
    final hour = selectedHour.toString().padLeft(2, '0');
    final minute = selectedMinute.toString().padLeft(2, '0');
    final am = selectedAmPm;

    setState(() {
      selectedTimes.add('$am $hour시 : $minute분');
    });
    Navigator.pop(context);
  }

  Future<void> saveTimerData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;

    final timerData = {
      'name': _timerNameController.text,
      'alarmTimes': selectedTimes,
      'medicines': [_medicineNameController.text],
      'startDate': _startDate.toString(),
      'endDate': _endDate.toString(),
      'memo': _memoController.text,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('medi')
        .doc('user')
        .collection('user')
        .doc(uid)
        .collection('timers')
        .add(timerData);
  }

  void _saveTimer() {
    if (!isFormValid) return;
    saveTimerData()
        .then((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('타이머가 저장되었습니다')));
        })
        .catchError((e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('저장에 실패했습니다')));
        });
  }

  void showDatePickerSheet({
    required DateTime? selectedDay,
    required void Function(DateTime) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: TableCalendar(
            locale: 'ko-KR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selected, focused) {
              onSelected(selected);
              setState(() => _focusedDay = focused);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildLabel(String title) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  Widget _buildDurationPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('복용기간'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed:
                    () => showDatePickerSheet(
                      selectedDay: _startDate,
                      onSelected: (date) => setState(() => _startDate = date),
                    ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xffC5C5C5),
                  minimumSize: const Size(double.infinity, 51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xffAEAEAE)),
                ),
                child: Text(
                  _startDate != null
                      ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                      : '시작일 선택하기',
                  style: TextStyle(color: Color(0xffC5C5C5)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed:
                    () => showDatePickerSheet(
                      selectedDay: _endDate,
                      onSelected: (date) => setState(() => _endDate = date),
                    ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xffC5C5C5),
                  minimumSize: const Size(double.infinity, 51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xffAEAEAE)),
                ),
                child: Text(
                  _endDate != null
                      ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                      : '종료일 선택하기',
                  style: TextStyle(color: Color(0xffC5C5C5)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget setTimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('알람시간'),
        const SizedBox(height: 8),
        ...selectedTimes.map(
          (time) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 8),
                Text(time, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {
            hourController.jumpToItem(0);
            minuteController.jumpToItem(30);
            ampmController.jumpToItem(0);
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 298,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TimerPicker(),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: updateSelectedTime,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                            backgroundColor: const Color(0xff23A3FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '알람시간 추가',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xffC5C5C5),
            minimumSize: const Size(double.infinity, 51),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: Color(0xffAEAEAE)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('알람시간 추가하기', style: TextStyle(fontSize: 15)),
              Icon(Icons.add, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget TimerPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPicker(
          controller: ampmController,
          max: 2,
          label: '',
          selectedIndex: safeSelectedIndex(ampmController, ampm.length),
          items: ampm,
        ),
        _buildPicker(
          controller: hourController,
          max: 12,
          label: '시',
          selectedIndex: safeSelectedIndex(hourController, 12),
          startFromOne: true,
        ),
        _buildPicker(
          controller: minuteController,
          max: 60,
          label: '분',
          selectedIndex: safeSelectedIndex(minuteController, 60),
        ),
      ],
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required int max,
    required String label,
    required int selectedIndex,
    bool startFromOne = false,
    List<String>? items,
  }) {
    return Row(
      children: [
        SizedBox(
          height: 100,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            physics: const FixedExtentScrollPhysics(),
            itemExtent: 50,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= max) return null;
                final value = startFromOne ? index + 1 : index;
                final displayText =
                    items != null
                        ? items[index]
                        : value.toString().padLeft(2, '0');
                final isSelected = index == selectedIndex;
                return Center(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors.black
                              : Colors.black.withOpacity(0.3),
                      fontSize: 24,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 28)),
      ],
    );
  }

  Widget InOutDataWidget(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffAEAEAE)),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xffC5C5C5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text('복용 일정 추가')),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLabel('복용 일정 이름'),
              InOutDataWidget(_timerNameController, '복용 일정의 이름을 입력해주세요'),
              const SizedBox(height: 20),
              _buildLabel('약 목록'),
              InOutDataWidget(_medicineNameController, '약 목록을 입력해주세요'),
              const SizedBox(height: 20),
              _buildDurationPicker(),
              const SizedBox(height: 20),
              _buildLabel('메모사항'),
              InOutDataWidget(_memoController, '메모사항을 입력해주세요'),
              const SizedBox(height: 20),
              setTimer(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isFormValid ? _saveTimer : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  backgroundColor:
                      isFormValid
                          ? const Color(0xff23A3FF)
                          : const Color(0xffE1E1E1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('복용 일정 추가'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

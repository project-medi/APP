import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: 0); // index 0 → 1시
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: 30); // 30분
  final FixedExtentScrollController ampmController =
      FixedExtentScrollController(initialItem: 0); // 오전

  List<String> ampm = ['오전', '오후'];
  String selectedTimeText = '';

  int get selectedHour =>
      hourController.hasClients ? hourController.selectedItem + 1 : 1;
  int get selectedMinute =>
      minuteController.hasClients ? minuteController.selectedItem : 0;
  String get selectedAmPm =>
      ampmController.hasClients ? ampm[ampmController.selectedItem] : ampm[0];

  void updateSelectedTime() {
    final hour = selectedHour.toString().padLeft(2, '0');
    final minute = selectedMinute.toString().padLeft(2, '0');
    final ampm = selectedAmPm;

    setState(() {
      selectedTimeText = '$ampm $hour시 : $minute분';
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateSelectedTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text('타이머')),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPicker(
                          controller: ampmController,
                          max: 2,
                          label: '',
                          selectedIndex:
                              ampmController.hasClients
                                  ? ampmController.selectedItem
                                  : 0,
                          items: ampm,
                          onSelectedItemChanged: (_) => updateSelectedTime(),
                        ),
                        _buildPicker(
                          controller: hourController,
                          max: 12,
                          label: '시',
                          selectedIndex:
                              hourController.hasClients
                                  ? hourController.selectedItem
                                  : 0,
                          startFromOne: true,
                          onSelectedItemChanged: (_) => updateSelectedTime(),
                        ),
                        _buildPicker(
                          controller: minuteController,
                          max: 60,
                          label: '분',
                          selectedIndex:
                              minuteController.hasClients
                                  ? minuteController.selectedItem
                                  : 0,
                          onSelectedItemChanged: (_) => updateSelectedTime(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: updateSelectedTime,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff23A3FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '알람시간 추가',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPicker({
  required FixedExtentScrollController controller,
  required int max,
  required String label,
  required int selectedIndex,
  bool startFromOne = false,
  List<String>? items,
  void Function(int)? onSelectedItemChanged,
}) {
  return Row(
    children: [
      SizedBox(
        height: 100,
        width: 60,
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          physics: const SlowScrollPhysics(),
          overAndUnderCenterOpacity: 0.3,
          perspective: 0.002,
          itemExtent: 50,
          onSelectedItemChanged: onSelectedItemChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              if (index >= max) return null;
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
              );
            },
            childCount: max,
          ),
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.black, fontSize: 28)),
    ],
  );
}

class SlowScrollPhysics extends FixedExtentScrollPhysics {
  const SlowScrollPhysics({super.parent});

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 0.5);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}

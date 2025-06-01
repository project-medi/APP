import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

Future<void> saveUserData({
  required String name,
  required String day,
  required String month,
  required String year,
  required String note,
  required String phoneNumber,
  required String weight,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final uid = user.uid;

  await FirebaseFirestore.instance
      .collection('medi')
      .doc('user')
      .collection('user')
      .doc(uid)
      .set({
        'uid': uid,
        'name': name.trim(),
        'day': day.trim(),
        'month': month.trim(),
        'year': year.trim(),
        'note': note.trim(),
        'phoneNumber': phoneNumber.trim(),
        'weight': weight.trim(),
      });
}

class EditMypage extends StatefulWidget {
  const EditMypage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditMypageState createState() => _EditMypageState();
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' - ', ' ');
    var buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 2 || i == 6) && i != text.length - 1) {
        buffer.write(' - ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _EditMypageState extends State<EditMypage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final weightController = TextEditingController();
  final noteController = TextEditingController();

  bool isFormFilled = false;

  @override
  void initState() {
    super.initState();

    nameController.addListener(_checkFormFilled);
    phoneNumberController.addListener(_checkFormFilled);
    dayController.addListener(_checkFormFilled);
    monthController.addListener(_checkFormFilled);
    yearController.addListener(_checkFormFilled);
    weightController.addListener(_checkFormFilled);
  }

  void _checkFormFilled() {
    setState(() {
      isFormFilled =
          nameController.text.trim().isNotEmpty &&
          phoneNumberController.text.trim().isNotEmpty &&
          dayController.text.trim().isNotEmpty &&
          weightController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    weightController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await saveUserData(
          name: nameController.text,
          day: dayController.text,
          month: monthController.text,
          year: yearController.text,
          note: noteController.text,
          phoneNumber: phoneNumberController.text,
          weight: weightController.text,
        );

        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('저장되었습니다.')));

        _formKey.currentState?.reset();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: ${e.toString()}')));
      }
    }
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 16.0, bottom: 0),
    child: Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(color: Color(0xff707070), fontSize: 17),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("프로필"),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(children: [UserDataUnit(), updateMypage()]),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget UserDataUnit() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildLabel('이름'),
            TextFormField(
              controller: nameController,
              cursorColor: Colors.black,
              validator: (v) => v!.isEmpty ? '필수 입력' : null,
              decoration: InputDecoration(
                hintText: '홍길동',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffAEAEAE)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffAEAEAE)),
                ),
              ),
            ),

            _buildLabel('전화번호'),
            TextFormField(
              controller: phoneNumberController,
              cursorColor: Colors.black,
              validator: (v) => v!.isEmpty ? '필수 입력' : null,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '010 - 1234 - 5678',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffAEAEAE)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffAEAEAE)),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                NumberFormatter(),
                LengthLimitingTextInputFormatter(17),
              ],
            ),

            _buildLabel('생년월일'),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: '2009',
                      suffixText: yearController.text.isNotEmpty ? '년도' : null,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAEAEAE)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAEAEAE)),
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: monthController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: '01',
                      suffixText: monthController.text.isNotEmpty ? '월' : null,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAEAEAE)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAEAEAE)),
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: dayController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: '31',
                      suffixText: dayController.text.isNotEmpty ? '일' : null,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAEAEAE)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAEAEAE)),
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            _buildLabel('몸무게'),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 60,
                child: TextFormField(
                  controller: weightController,
                  cursorColor: Colors.black,
                  validator: (v) => v!.isEmpty ? '필수 입력' : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'WW',
                    suffixText: weightController.text.isNotEmpty ? 'kg' : null,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 0,
                    ),
                    suffixStyle: TextStyle(color: Color(0xffAEAEAE)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffAEAEAE)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffAEAEAE)),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),

            _buildLabel('특이사항'),
            TextFormField(
              controller: noteController,
              cursorColor: Colors.black,
              maxLines: null,
              decoration: InputDecoration(
                hintText: '가지고 있는 지병이나 기타 질환을 입력해주세요',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffAEAEAE)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffAEAEAE)),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*위 정보들은 119 구급대원님들에게 제공됩니다',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox updateMypage() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isFormFilled ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text("프로필 등록"),
      ),
    );
  }
}

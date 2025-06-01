import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetpasswordPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  late final ActionCodeSettings actionCodeSettings;

  ResetpasswordPage({super.key, required String oobcode}) {
    actionCodeSettings = ActionCodeSettings(
      url: "http://www.medi.com/verify?email=${user?.email}",
      iOSBundleId: "com.example.ios",
      androidPackageName: "com.example.android",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

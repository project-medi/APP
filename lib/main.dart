import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_medi/firebase_options.dart';
import 'package:project_medi/page/app/start_splash_page.dart';
import 'package:project_medi/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instanceFor(app: Firebase.app());
  await initializeDateFormatting('ko_KR');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.path.contains('resetPassword')) {
        final code = uri.queryParameters['oobCode'];
        if (code != null) {
          router.go('/reset-password?oobCode=$code');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StartSplashPage(),
    );
  }
}

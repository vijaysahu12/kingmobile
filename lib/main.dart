import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kraapp/Screens/Login_Info/getotp_verification.dart';

import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 252, 251, 251),
        body: MyHomeScreen(),
      ),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreen();
}

class _MyHomeScreen extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetMobileOtp();
  }
}

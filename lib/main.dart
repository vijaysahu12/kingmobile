import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kraapp/Screens/LoginRegister/loginRegisterNew/getotp_verification.dart';
import 'package:kraapp/Screens/all_screens.dart';

//import 'package:kraapp/Screens/login_and_register/login_screen.dart';

import 'Helpers/sharedPref.dart';
import 'Screens/Common/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  SharedPref _sharedPref = SharedPref();
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    String userId = await _sharedPref.read("KingUserToken");

    setState(() {
      isLoggedIn = userId.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: isLoggedIn ? HomeScreen() : GetMobileOtp(),
      ),
    );
  }
}
